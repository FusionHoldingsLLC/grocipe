// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// // import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// // import 'package:top_snackbar_flutter/safe_area_values.dart';
// // import 'package:top_snackbar_flutter/tap_bounce_container.dart';
// // import 'package:top_snackbar_flutter/top_snack_bar.dart';
// // import '../settings/constants.dart';

// enum options { success, failure, warning, info }

// class MyMessageHandler {
//   static void showSnackBar(BuildContext context, String message,
//       {options option = options.failure, String? title}) {
//     SnackBar? snackBar;
//     switch (option) {
//       case options.success:
//         snackBar = SnackBar(
//           /// need to set following properties for best effect of awesome_snackbar_content
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: title ?? 'Congratulations',
//             message: message,

//             /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//             contentType: ContentType.success,
//           ),
//         );
//       case options.failure:
//         snackBar = SnackBar(
//           /// need to set following properties for best effect of awesome_snackbar_content
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: title ?? 'On Snap!',
//             message: message,

//             /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//             contentType: ContentType.failure,
//           ),
//         );
//         break;
//       case options.warning:
//         snackBar = SnackBar(
//           /// need to set following properties for best effect of awesome_snackbar_content
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: title ?? 'Warning!',
//             message: message,

//             /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//             contentType: ContentType.warning,
//           ),
//         );
//         break;
//       case options.info:
//         snackBar = SnackBar(
//           /// need to set following properties for best effect of awesome_snackbar_content
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: title ?? 'Hi There!',
//             message: message,

//             /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//             contentType: ContentType.help,
//           ),
//         );
//       default:
//         snackBar = SnackBar(
//           /// need to set following properties for best effect of awesome_snackbar_content
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: title ?? 'On Snap!',
//             message: message,

//             /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//             contentType: ContentType.failure,
//           ),
//         );
//     }
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//     // ScaffoldMessenger.of(context)
//     //   ..hideCurrentSnackBar()
//     //   ..hideCurrentMaterialBanner()
//     //   ..showSnackBar(snackBar);
//   }
// }
