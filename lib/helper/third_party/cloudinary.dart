// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryDev {
  static Cloudinary CloudinaryKey = Cloudinary.signedConfig(
    apiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '',
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ?? '',
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '',
  );
  static Future uploadPicture({
    required String path,
    required String folder,
    required fileName,
  }) async {
    final cloudinary = CloudinaryDev.CloudinaryKey;
    try {
      var response = await cloudinary.upload(
        file: path,
        // fileBytes: file.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        fileName: '$fileName',
        progressCallback: (count, total) {
          print('Uploading image from file with progress: $count/$total');
        },
      );
      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        return {'message': response.error};
      }
    } catch (e) {
      return {'message': "Check your network"};
    }
  }
}
