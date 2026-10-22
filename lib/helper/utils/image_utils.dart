// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class ImageUtils {
  static const defaultImage =
      "https://fieldmaxpro.s3-us-west-2.amazonaws.com/fmp_10002/contacts/07-2023/5hOvf0qWFn31hldTZ8SLVoQo8EqXhsT4lj3.jpg";

  static String fileName(String filePath) => filePath.split('/').last;

  static const List<String> allowedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
  ];

  static Future<String> localFileToBase64(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    String base64string = base64.encode(imageBytes);
    return base64string;
  }

  static Future<File> downloadImage(String imageUrl) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = path.basename(imageUrl);
    final File file = File('${tempDir.path}/$fileName');
    final http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static Future<String> assetFileToBase64(String assetPath) async {
    ByteData bytes = await rootBundle.load(assetPath);
    var buffer = bytes.buffer;
    var base64String = base64.encode(Uint8List.view(buffer));
    return base64String;
  }

  static Uint8List memoryImageFromBase64(String base64Image) =>
      const Base64Decoder().convert(base64Image);

  // use with Image.network widget
  static dynamic decodeBase64(String encoded) {
    String decoded = utf8.decode(base64Url.decode(encoded));
    return decoded;
  }

  // Throws exception
  static Future<File?> pickImage([int quality = 50]) async {
    ImageSource source = kDebugMode ? ImageSource.gallery : ImageSource.camera;
    XFile? file = await ImagePicker().pickImage(
      source: source,
      imageQuality: quality,
    );

    if (file == null) return null;

    /// Check file uses allowed file extensions
    bool hasAllowedExtension = false;
    for (final extension in allowedExtensions) {
      if (file.path.toLowerCase().endsWith(extension)) {
        hasAllowedExtension = true;
      }
    }

    if (hasAllowedExtension) {
      return File(file.path);
    } else {
      throw "Only ${allowedExtensions.toString().replaceAll("[", "").replaceAll("]", "")} files are allowed";
    }
  }

  static const imgPermissions = [Permission.camera, Permission.storage];
  static Future<bool> requestImagePermissions() async {
    bool success = false;
    try {
      final status = await imgPermissions.request();
      for (final status in status.values) {
        success = status == PermissionStatus.limited ||
            status == PermissionStatus.granted;
      }
    } catch (_) {
      log("Image Utils: Image Permissions Request failed");
    }
    return success;
  }
}
