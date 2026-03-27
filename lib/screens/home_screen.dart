import 'package:cellreport/repositories/announcement.dart';
import 'package:cellreport/widgets/announcement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showAnnouncement();
    });
  }

  Future<void> _showAnnouncement() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final announcementRepository = AnnouncementRepository(
      Supabase.instance.client,
      packageInfo.packageName,
    );
    final announcement = await announcementRepository.getLatestAnnouncement();
    if (announcement != null) {
      await AnnouncementDialog.show(context, announcement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈화면'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('기능을 추가해주세요', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
