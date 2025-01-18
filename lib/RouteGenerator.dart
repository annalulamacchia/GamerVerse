import 'package:flutter/material.dart';
import 'package:gamerverse/views/admin_report_page.dart';
import 'package:gamerverse/views/home/all_games_page.dart';
import 'package:gamerverse/views/community/comment_page.dart';
import 'package:gamerverse/views/community/advised_users_page.dart';
import 'package:gamerverse/views/community/community_page.dart';
import 'package:gamerverse/views/profile/complete_list_of_games_page.dart';
import 'package:gamerverse/views/home_page.dart';
import 'package:gamerverse/views/login/loginEmail_page.dart';
import 'package:gamerverse/views/login/login_page.dart';
import 'package:gamerverse/views/login/newPassword_page.dart';
import 'package:gamerverse/views/profile/user_profile_page.dart';
import 'package:gamerverse/views/home/popular_games_page.dart';
import 'package:gamerverse/views/profile/profile_page.dart';
import 'package:gamerverse/views/profile/profile_settings_page.dart';
import 'package:gamerverse/views/home/released_this_month_page.dart';
import 'package:gamerverse/views/login/resetPassword_page.dart';
import 'package:gamerverse/views/home/search_page.dart';
import 'package:gamerverse/views/login/signup_page.dart';
import 'package:gamerverse/views/specific_game/all_reviews.dart';
import 'package:gamerverse/views/specific_game/liked_list.dart';
import 'package:gamerverse/views/specific_game/played_list.dart';
import 'package:gamerverse/views/specific_game/series_games.dart';
import 'package:gamerverse/views/specific_game/specific_game.dart';
import 'package:gamerverse/views/profile/specific_user_game.dart';
import 'package:gamerverse/views/home/upcoming_games_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/community':
        return MaterialPageRoute(builder: (context) => const CommunityPage());
      case '/suggestedUsers':
        return MaterialPageRoute(
            builder: (context) => const AdvisedUsersPage());
      case '/profile':
        return MaterialPageRoute(
          builder: (context) => ProfilePage(),
        );
      case '/game':
        if (args is int) {
          return MaterialPageRoute(
              builder: (context) => SpecificGame(
                    gameId: args,
                  ));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/allGames':
        return MaterialPageRoute(builder: (context) => const AllGamesPage());
      case '/popularGames':
        return MaterialPageRoute(
            builder: (context) => const PopularGamesPage());
      case '/releasedGames':
        return MaterialPageRoute(
            builder: (context) => const ReleasedThisMonthPage());
      case '/upcomingGames':
        return MaterialPageRoute(
            builder: (context) => const UpcomingGamesPage());
      case '/search':
        return MaterialPageRoute(builder: (context) => const SearchPage());
      case '/login':
        if (args is String) {
          return MaterialPageRoute(
              builder: (context) => LoginPage(
                    currentPage: args,
                  ));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => ResetPasswordPage());
      case '/emailLogin':
        if (args is String) {
          return MaterialPageRoute(
              builder: (context) => LoginEmailPage(currentPage: args));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/signup':
        if (args is String) {
          return MaterialPageRoute(
              builder: (context) => SignupPage(currentPage: args));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/comments':
        if (args is Map<String, dynamic> &&
            args.containsKey('postId') &&
            args.containsKey('currentUser') &&
            args.containsKey('commentNotifier')) {
          return MaterialPageRoute(
              builder: (context) => CommentsPage(
                    postId: args['postId'],
                    currentUser: args['currentUser'],
                    commentNotifier: args['commentNotifier'],
                  ));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/suggestedUsers':
        return MaterialPageRoute(
            builder: (context) => const AdvisedUsersPage());
      case '/userProfile':
        if (args is String) {
          return MaterialPageRoute(
            builder: (context) => UserProfilePage(userId: args),
          );
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/profileSettings':
        return MaterialPageRoute(
            builder: (context) => const AccountSettingsPage());
      case '/userAllGames':
        if (args is Map<String, dynamic> &&
            args.containsKey('games') &&
            args.containsKey('currentUser') &&
            args.containsKey('userId')) {
          return MaterialPageRoute(
              builder: (context) => AllGamesUserPage(
                  games: args['games'],
                  currentUser: args['currentUser'],
                  userId: args['userId']));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/userGame':
        if (args is Map<String, dynamic> &&
            args.containsKey('game') &&
            args.containsKey('currentUser') &&
            args.containsKey('userId') &&
            args.containsKey('currentFollowedNotifier')) {
          return MaterialPageRoute(
              builder: (context) => SpecificUserGame(
                    game: args['game'],
                    currentUser: args['currentUser'],
                    userId: args['userId'],
                    currentFollowedNotifier: args['currentFollowedNotifier'],
                  ));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/admin':
        return MaterialPageRoute(builder: (context) => const AdminReportPage());
      case '/allReviews':
        if (args is Map<String, dynamic> &&
            args.containsKey('userId') &&
            args.containsKey('game') &&
            args.containsKey('onLoadAverageRating') &&
            args.containsKey('averageUserReviewNotifier') &&
            args.containsKey('latestReviewNotifier') &&
            args.containsKey('onLoadLatestReview')) {
          return MaterialPageRoute(
              builder: (context) => ReviewPage(
                  userId: args['userId'],
                  game: args['game'],
                  onLoadAverageRating: args['onLoadAverageRating'],
                  averageUserReviewNotifier: args['averageUserReviewNotifier'],
                  latestReviewNotifier: args['latestReviewNotifier'],
                  onLoadLatestReview: args['onLoadLatestReview']));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/likedList':
        if (args is Map<String, dynamic> &&
            args.containsKey('users') &&
            args.containsKey('currentUser') &&
            args.containsKey('gameName')) {
          return MaterialPageRoute(
              builder: (context) => LikedList(
                    users: args['users'],
                    currentUser: args['currentUser'],
                    gameName: args['gameName'],
                  ));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/playedList':
        if (args is Map<String, dynamic> &&
            args.containsKey('game') &&
            args.containsKey('userId')) {
          return MaterialPageRoute(
              builder: (context) =>
                  PlayedList(game: args['game'], userId: args['userId']));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/newPassword':
        if (args is Map<String, dynamic> && args.containsKey('email')) {
          return MaterialPageRoute(
            builder: (context) => NewPasswordPage(email: args['email']),
          );
        }
        return MaterialPageRoute(builder: (context) => const HomePage());

      case '/series':
        if (args is Map<String, dynamic> &&
            args.containsKey('gameIds') &&
            args.containsKey('title')) {
          return MaterialPageRoute(
              builder: (context) =>
                  SeriesGame(gameIds: args['gameIds'], title: args['title']));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}
