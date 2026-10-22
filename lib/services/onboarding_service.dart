import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/api/network.dart';
import 'package:grocipe/api/api_urls.dart';

class OnboardingService {
  final Ref ref;

  OnboardingService(this.ref);

  Network get network => ref.read(networkProvider);

  Future<void> submitSurvey(Map<String, dynamic> surveyData) async {
    await network.call(
      UrlConfig.submitSurvey,
      RequestMethod.post,
      data: surveyData,
      showLog: true,
    );
  }

  Future<void> submitSurveyAuth(Map<String, dynamic> surveyData) async {
    await network.call(
      UrlConfig.submitSurveyAuth,
      RequestMethod.post,
      data: surveyData,
      showLog: true,
    );
  }

  Future<Map<String, dynamic>> getSurvey() async {
    final res = await network.call(
      UrlConfig.getSurvey,
      RequestMethod.get,
      showLog: true,
    );
    return res.data;
  }

  Future<void> updateSurvey(Map<String, dynamic> surveyData) async {
    await network.call(
      UrlConfig.updateSurvey,
      RequestMethod.put,
      data: surveyData,
      showLog: true,
    );
  }
}

final onboardingService =
    Provider<OnboardingService>((ref) => OnboardingService(ref));
