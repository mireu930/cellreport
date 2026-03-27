import 'package:cellreport/screens/announcement_list_screen.dart';
import 'package:cellreport/screens/home_screen.dart';
import 'package:cellreport/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/announcements',
      builder: (context, state) => const AnnouncementListScreen(),
    ),
  ],
);
