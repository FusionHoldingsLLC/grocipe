library network;

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/helper/constants/globals.dart';
import 'package:grocipe/models/events/file_transfer_progress_event.dart';
import 'package:grocipe/models/events/session_expired_event.dart';
import 'package:grocipe/api/error_interpolator.dart';
import 'package:grocipe/api/api_urls.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/logger.dart';

part 'api_error.dart';
part 'app_interceptor.dart';
part 'network_provider.dart';
