import 'dart:io';

import 'package:cellreport/clients/discord_webhook.dart';
import 'package:cellreport/widgets/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<PackageInfo> _getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정화면')),
      body: ListView(
        children: [
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('앱 버전'),
            subtitle: FutureBuilder(
              future: _getPackageInfo(),
              builder: (context, snapshot) {
                return Text(snapshot.data?.version ?? '불러오는 중...');
              },
            ),
          ),
          Divider(height: 0),
          ListTile(
            minVerticalPadding: 25,
            leading: Icon(Icons.description_outlined),
            title: Text('서비스 소개'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              //
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text('서비스 소개'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('서비스 한 줄 소개'),
                      SizedBox(height: 8),
                      Text('서비스 목적'),
                      SizedBox(height: 8),
                      Text('사용자'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(height: 0),
          ListTile(
            minVerticalPadding: 25,
            leading: Icon(Icons.mail_outline),
            title: Text('고객 문의/제안'),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              var feedback = await FeedbackDialog.show(context);
              //print(feedback);

              if (feedback == null) {
                return;
              }

              final pacakageInfo = await _getPackageInfo();
              final title =
                  '${feedback['category']} :: ${pacakageInfo.appName} ${pacakageInfo.version}';
              final deviceInfo =
                  '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
              String message = '💬${feedback['message']}';
              message +=
                  '\n\n📨${feedback['email']!.isNotEmpty ? feedback['email'] : '제공하지 않음'}';
              message += '\n\n💻$deviceInfo';

              final priority = switch (feedback['category']) {
                '기능제안' => Priority.low,
                '버그신고' => Priority.high,
                '기타문의' => Priority.medium,
                _ => Priority.low,
              };

              DiscordWebhook().sendMessage(
                title: title,
                message: message,
                priority: priority,
              );

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('문의/제안이 전송되었습니다.')));
            },
          ),
          Divider(height: 0),
          ListTile(
            minVerticalPadding: 25,
            leading: Icon(Icons.description_outlined),
            title: Text('공지사항'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              context.push('/announcements');
            },
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}
