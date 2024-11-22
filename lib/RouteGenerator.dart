import 'package:flutter/material.dart';
import 'package:gamerverse/views/admin_report_page.dart';
import 'package:gamerverse/views/home/all_games_page.dart';
import 'package:gamerverse/views/common_sections/comment_page.dart';
import 'package:gamerverse/views/community/advised_users_page.dart';
import 'package:gamerverse/views/community/community_page.dart';
import 'package:gamerverse/views/complete_list_of_games_page.dart';
import 'package:gamerverse/views/home_page.dart';
import 'package:gamerverse/views/login/loginEmail_page.dart';
import 'package:gamerverse/views/login/login_page.dart';
import 'package:gamerverse/views/login/newPassword_page.dart';
import 'package:gamerverse/views/other_user_profile/user_post_page.dart';
import 'package:gamerverse/views/other_user_profile/user_profile_page.dart';
import 'package:gamerverse/views/home/popular_games_page.dart';
import 'package:gamerverse/views/profile/profile_page.dart';
import 'package:gamerverse/views/profile/profile_post_page.dart';
import 'package:gamerverse/views/profile/profile_reviews_page.dart';
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
import 'package:gamerverse/views/specific_user_game.dart';
import 'package:gamerverse/views/home/upcoming_games_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/community':
        return MaterialPageRoute(builder: (context) => const CommunityPage());
      case '/profile':
        return MaterialPageRoute(builder: (context) => const ProfilePage());
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
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => ResetPasswordPage());
      case '/emailLogin':
        return MaterialPageRoute(builder: (context) => const LoginEmailPage());
      case '/signup':
        return MaterialPageRoute(builder: (context) => const SignupPage());
      case '/comments':
        return MaterialPageRoute(builder: (context) => CommentsPage());
      case '/suggestedUsers':
        return MaterialPageRoute(
            builder: (context) => const AdvisedUsersPage());
      case '/userProfile':
        return MaterialPageRoute(builder: (context) => const UserProfilePage());
      case '/profileReviews':
        return MaterialPageRoute(
            builder: (context) => const ProfileReviewsPage());
      case '/profilePosts':
        return MaterialPageRoute(builder: (context) => const ProfilePostPage());
      case '/userPosts':
        return MaterialPageRoute(builder: (context) => const UserPostPage());
      case '/profileSettings':
        return MaterialPageRoute(
            builder: (context) => const AccountSettingsPage());
      case '/userAllGames':
        if (args is List<String>) {
          return MaterialPageRoute(
              builder: (context) => AllgamesPage(imageUrls: args));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/userGame':
        return MaterialPageRoute(
            builder: (context) => const SpecificUserGame());
      case '/admin':
        return MaterialPageRoute(builder: (context) => const AdminReportPage());
      case '/allReviews':
        return MaterialPageRoute(builder: (context) => const ReviewPage());
      case '/likedList':
        return MaterialPageRoute(builder: (context) => const LikedList());
      case '/playedList':
        return MaterialPageRoute(builder: (context) => const PlayedList());
      case '/newPassword':
        return MaterialPageRoute(builder: (context) => NewPasswordPage());
      case '/series':
        return MaterialPageRoute(builder: (context) => const SeriesGame());
      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}
