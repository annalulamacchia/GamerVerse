import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/home/category_section.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/services/game_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? allGames;
  List<Map<String, dynamic>>? popularGames;
  List<Map<String, dynamic>>? releasedThisMonthGames;
  List<Map<String, dynamic>>? upcomingGames;

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    try {
      final all = await GameApiService.fetchGameDataList();
      final popular = await GameApiService.fetchPopularGames();
      final releasedThisMonth =
          await GameApiService.fetchReleasedThisMonthGames();
      final upcoming = await GameApiService.fetchUpcomingGames();

      setState(() {
        allGames = all?.take(10).toList();
        popularGames = popular?.take(10).toList();
        releasedThisMonthGames = releasedThisMonth?.take(10).toList();
        upcomingGames = upcoming?.take(10).toList();
      });
    } catch (e) {
      print('Error fetching games: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          CategorySection(
            title: 'All Games',
            onArrowTap: () {
              Navigator.pushNamed(context, '/allGames');
            },
            games: allGames,
          ),
          CategorySection(
            title: 'Popular Games',
            onArrowTap: () {
              Navigator.pushNamed(context, '/popularGames');
            },
            games: popularGames,
          ),
          CategorySection(
            title: 'Released this Month',
            onArrowTap: () {
              Navigator.pushNamed(context, '/releasedGames');
            },
            games: releasedThisMonthGames,
          ),
          CategorySection(
            title: 'Upcoming Games',
            onArrowTap: () {
              Navigator.pushNamed(context, '/upcomingGames');
            },
            games: upcomingGames,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
