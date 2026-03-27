import 'package:cellreport/repositories/announcement.dart';
import 'package:cellreport/router.dart';
import 'package:cellreport/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final announcementRepository = AnnouncementRepository(
    Supabase.instance.client,
    "com.example.cellreport",
  );

  final announcements = await announcementRepository.getLatestAnnouncement();

  // print(announcements);
  // print(announcements?.title);
  // print(announcements?.content);
  // print(announcements?.createdAt);
  // print(announcements?.appId);
  // print(announcements?.isActive);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      //theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: Text('Hello, World!')));
//   }
// }
