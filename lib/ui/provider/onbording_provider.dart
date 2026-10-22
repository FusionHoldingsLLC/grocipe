// ignore_for_file: unused_catch_clause, avoid_print

import 'dart:convert';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/services/onboarding_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingState {
  final String cookingFrequency;
  final String cookingFor;
  final String recipeSource;
  final String heardFrom;
  final List<String> expectations;

  OnboardingState({
    this.cookingFrequency = '',
    this.cookingFor = '',
    this.recipeSource = '',
    this.heardFrom = '',
    this.expectations = const [],
  });

  OnboardingState copyWith({
    String? cookingFrequency,
    String? cookingFor,
    String? recipeSource,
    String? heardFrom,
    List<String>? expectations,
  }) {
    return OnboardingState(
      cookingFrequency: cookingFrequency ?? this.cookingFrequency,
      cookingFor: cookingFor ?? this.cookingFor,
      recipeSource: recipeSource ?? this.recipeSource,
      heardFrom: heardFrom ?? this.heardFrom,
      expectations: expectations ?? this.expectations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cooking_frequency': cookingFrequency,
      'cooking_for': cookingFor,
      'recipe_source': recipeSource,
      'heard_from': heardFrom,
      'expectations': expectations,
    };
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingService _service;

  OnboardingNotifier(this._service) : super(OnboardingState());

  void updateCookingFrequency(String value) {
    state = state.copyWith(cookingFrequency: value);
  }

  void updateCookingFor(String value) {
    state = state.copyWith(cookingFor: value);
  }

  void updateRecipeSource(String value) {
    state = state.copyWith(recipeSource: value);
  }

  void updateHeardFrom(String value) {
    state = state.copyWith(heardFrom: value);
  }

  void updateExpectations(List<String> values) {
    state = state.copyWith(expectations: values);
  }

  bool isLoading = false;

  Future<void> submitSurvey() async {
    try {
      print(state.toJson());
      // await _service.submitSurvey(state.toJson());
      isLoading = true;
      await saveSurveyLocally(state.toJson());
      isLoading = false;
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  Future<bool> userHasSurvey() async {
    try {
      isLoading = true;
      Dio dio = Dio();
      Options options = Options(
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
      );
      Response surveyData = await dio.get(
        'https://dev.grocipe.app/api/v1/onboarding/response',
        options: options,
      );
      print(surveyData.data);
      if (surveyData.data['id'] != null) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      isLoading = false;
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> submitSurveyToApi() async {
    try {
      var loadSurvey = await loadSurveyLocally();

      if (loadSurvey != null) {
        await _service.submitSurveyAuth(loadSurvey);
        await clearSurveyLocally();
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  Future<void> submitSurveyAuth() async {
    await _service.submitSurveyAuth(state.toJson());
  }

  Future<void> updateSurvey() async {
    await _service.updateSurvey(state.toJson());
  }

  Future<void> loadSurvey() async {
    final surveyData = await _service.getSurvey();
    state = OnboardingState(
      cookingFrequency: surveyData['cooking_frequency'] ?? '',
      cookingFor: surveyData['cooking_for'] ?? '',
      recipeSource: surveyData['recipe_source'] ?? '',
      heardFrom: surveyData['heard_from'] ?? '',
    );
  }

  Future<bool> saveSurveyLocally(Map<String, dynamic> surveyData) async {
    final prefs = await SharedPreferences.getInstance();
    var success = await prefs.setString('survey_data', jsonEncode(surveyData));
    return success;
  }

  Future<Map<String, String>?> loadSurveyLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final String? surveyString = prefs.getString('survey_data');
    if (surveyString != null) {
      return Map<String, String>.from(jsonDecode(surveyString));
    }
    return null;
  }

  Future<void> clearSurveyLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('survey_data');
  }
}

// Create a provider for the StateNotifier
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final service = ref.read(onboardingService);
  return OnboardingNotifier(service);
});
