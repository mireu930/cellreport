import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum Priority { low, medium, high }

class DiscordWebhook {
  int _getColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 0x4E8AF2;
      case Priority.medium:
        return 0xECF23F;
      case Priority.high:
        return 0xF54927;
      default:
        return 0x4EF277;
    }
  }

  Future<void> sendMessage({
    required String title,
    required String message,
    Priority priority = Priority.low,
  }) async {
    final embeds = {
      'embeds': [
        {
          'title': title,
          'description': message,
          'color': _getColor(priority),
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      ],
    };
    final response = await http.post(
      Uri.parse(dotenv.env['DISCORD_WEBHOOK_URL']!),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(embeds),
    );
    if (response.statusCode != 204) {
      debugPrint('Discord Webhook 전송 실패: ${response.statusCode}');
    }
  }
}
