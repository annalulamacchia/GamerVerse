import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';

class FavoriteButton extends StatefulWidget {
  final String? userId;
  final Game? game;
  final ValueNotifier<int> likedCountNotifier;
  final Future<void> Function() onLoadWishlist;

  const FavoriteButton(
      {super.key,
      required this.userId,
      required this.game,
      required this.likedCountNotifier,
      required this.onLoadWishlist});

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _loadGameInWishlist();
    }
  }

  //load if the game is in the wishlist of the current user
  Future<void> _loadGameInWishlist() async {
    final isGameFound = await WishlistService.gameIsInWishlist(
        userId: widget.userId, game: widget.game);
    setState(() {
      if (isGameFound == true) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }
      isLoading = false;
    });
  }

  //function to alternate favourite (add to wishlist) and not favourite (remove from wishlist)
  void _toggleFavorite() async {
    isFavorite = !isFavorite;
    if (isFavorite) {
      await WishlistService.addGameToWishlist(
          userId: widget.userId, game: widget.game);
      widget.onLoadWishlist();
    }
    if (!isFavorite) {
      await WishlistService.removeGameFromWishlist(
          userId: widget.userId, game: widget.game);
      widget.onLoadWishlist();
    }
  }

  //function to redirect to login if the user is not logged
  void _toLoginForWishlist() {
    Navigator.pushNamed(context, '/login', arguments: widget.game!.id);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading && widget.userId != null
        ? Center(
            child: Opacity(
              opacity: 0,
              child: CircularProgressIndicator(),
            ),
          )
        : IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed:
                widget.userId != null ? _toggleFavorite : _toLoginForWishlist,
          );
  }
}
