import 'package:cellreport/models/announcement.dart';
import 'package:cellreport/repositories/announcement.dart';
import 'package:cellreport/widgets/announcement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementListScreen extends StatelessWidget {
  const AnnouncementListScreen({super.key});

  Future<List<Announcement>> _loadAnnouncements() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final repository = AnnouncementRepository(
      Supabase.instance.client,
      packageInfo.packageName,
    );
    return repository.getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항')),
      body: FutureBuilder<List<Announcement>>(
        future: _loadAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('공지사항을 불러오지 못했어요.\n${snapshot.error}'));
          }

          final announcements = snapshot.data ?? [];

          if (announcements.isEmpty) {
            return const Center(child: Text('등록된 공지사항이 없습니다.'));
          }

          return ListView.separated(
            itemCount: announcements.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return ListTile(
                title: Text(announcement.title),
                subtitle: Text(
                  announcement.createdAt.toLocal().toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AnnouncementDialog(
                      announcement: announcement,
                      showDontShowAgainOption: false,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
