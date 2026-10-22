// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/api/api_urls.dart';
import 'package:http_parser/http_parser.dart';
import 'package:grocipe/api/network.dart';

class UploadService {
  final Ref ref;
  UploadService(this.ref);

  Network get network => ref.read(networkProvider);

  Future<List<String>> upload({
    required List<File> files,
  }) async {
    FormData formData = FormData.fromMap({
      "images": await _getMultipartFiles(files),
    });
    var res = await network.call(UrlConfig.baseUrl, RequestMethod.upload,
        data: formData, classTag: "upload", showLog: true);
    return [(res.data)];
  }

  static Future<List<MultipartFile>> _getMultipartFiles(
    List<File> files,
  ) async {
    List<MultipartFile> multipartFiles = [];
    for (File file in files) {
      var multipart = await MultipartFile.fromFile(file.path,
          filename: file.path.split("/").last,
          contentType: MediaType('image', 'jpeg'));
      multipartFiles.add(multipart);
    }
    return multipartFiles;
  }
}

final uploadService = Provider<UploadService>((ref) => UploadService(ref));
