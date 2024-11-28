import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/home/category_section.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/services/gameApiService.dart';

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
      final releasedThisMonth = await GameApiService.fetchReleasedThisMonthGames();
      final upcoming = await GameApiService.fetchUpcomingGames();

      setState(() {
        allGames = all?.take(4).toList();
        popularGames = popular?.take(4).toList();
        releasedThisMonthGames = releasedThisMonth?.take(4).toList();
        upcomingGames = upcoming?.take(4).toList();
      });
    } catch (e) {
      print('Error fetching games: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
