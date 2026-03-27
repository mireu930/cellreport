import 'package:cellreport/models/announcement.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementDialog extends StatefulWidget {
  final Announcement announcement;

  /// true면 '이 창을 더이상 열지 않겠습니다' 체크박스 표시 (홈 등). false면 표시 안 함 (공지 목록 등).
  final bool showDontShowAgainOption;
  const AnnouncementDialog({
    super.key,
    required this.announcement,
    this.showDontShowAgainOption = true,
  });
  static const String _viewedAnnouncementKey = 'viewed_announcement';

  static Future<void> _setViewed(int announcementId) async {
    final prefs = await SharedPreferences.getInstance();
    final viewdIds = prefs.getStringList(_viewedAnnouncementKey) ?? [];

    if (!viewdIds.contains(announcementId.toString())) {
      viewdIds.add(announcementId.toString());
    }

    await prefs.setStringList(_viewedAnnouncementKey, viewdIds);
  }

  static Future<bool> _isViewed(int announcementId) async {
    final prefs = await SharedPreferences.getInstance();
    final viewdIds = prefs.getStringList(_viewedAnnouncementKey) ?? [];
    return viewdIds.contains(announcementId.toString());
  }

  /// 홈 화면 등에서 사용. 이미 본 공지(체크 후 확인한 공지)면 띄우지 않음.
  static Future<void> show(
    BuildContext context,
    Announcement announcement,
  ) async {
    if (await _isViewed(announcement.id)) {
      return;
    }

    if (context.mounted) {
      final dontShowAgain = await showDialog<bool>(
        context: context,
        builder: (context) => AnnouncementDialog(
          announcement: announcement,
          showDontShowAgainOption: true,
        ),
      );
      if (context.mounted && dontShowAgain == true) {
        await _setViewed(announcement.id);
      }
    }
  }

  @override
  State<AnnouncementDialog> createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<AnnouncementDialog> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(widget.announcement.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.announcement.content),
            if (widget.showDontShowAgainOption) ...[
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _dontShowAgain,
                onChanged: (value) {
                  setState(() => _dontShowAgain = value ?? false);
                },
                title: const Text('이 창을 더이상 열지 않겠습니다'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            widget.showDontShowAgainOption ? _dontShowAgain : false,
          ),
          child: const Text('확인'),
        ),
      ],
    );
  }
}
