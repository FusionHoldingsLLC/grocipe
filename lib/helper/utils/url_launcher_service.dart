import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class AppInterfaceService {
  static Future<void> _launchURL(String url) async =>
      await launchUrl(Uri.parse(url));

  static Future<void> mailTo(String? emailAddress,
      {String subject = ''}) async {
    if (emailAddress == null) return;
    try {
      final uri = 'mailto:$emailAddress?subject=$subject';
      return await _launchURL(uri);
    } catch (_) {
      throw 'Could not launch email app';
    }
  }

  static Future<void> phoneCall(String? phone) async {
    if (phone == null) return;
    try {
      final uri = 'tel:$phone';
      return await _launchURL(uri);
    } catch (_) {
      throw 'Could not launch phone app';
    }
  }

  static Future<void> launchLink(String? link) async {
    if (link == null) return;
    try {
      final uri = link;
      return await _launchURL(uri);
    } catch (_) {
      throw 'Could not launch link';
    }
  }

  static void copyToClipboard(String val) =>
      Clipboard.setData(ClipboardData(text: val));
}
