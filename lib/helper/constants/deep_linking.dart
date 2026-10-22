// ignore_for_file: avoid_print, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class AppLinksDeepLink {
  static Future<void> initDeepLinks(BuildContext context) async {
    late AppLinks _appLinks;
    StreamSubscription<Uri>? _linkSubscription;
    _appLinks = AppLinks();
    void openAppLink(Uri uri) {
      print(uri.data);
      print(uri.origin);
      print(uri.pathSegments);
      final path = uri.path;
      print(path);

      print("---sfjob-");
      // context.goNamed(path);
    }

    // // Handle initial link
    final initialUri = await _appLinks.getLatestLink();
    final initialUri2 = await _appLinks.getLatestLinkString();

    print(initialUri);
    print(initialUri2);
    if (initialUri != null) {
      debugPrint('onAppLink: $initialUri');

      openAppLink(initialUri);
    }

    // // Handle incoming links
    // _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
    //   debugPrint('onAppLink: $uri');
    //   openAppLink(uri);
    // });
  }
}
