enum UrlEnvironment { development, production }

class UrlConfig {
  static UrlEnvironment _environment = UrlEnvironment.production;
  static UrlEnvironment get environment => _environment;
  static void setEnvironment(UrlEnvironment env) => _environment = env;

  static String get baseUrl => "$_baseUrl/api/v1/";

  static get _baseUrl {
    switch (_environment) {
      case UrlEnvironment.development:
        return 'https://dev.grocipe.app';
      case UrlEnvironment.production:
        return 'https://dev.grocipe.app';
    }
  }

  // ${Constants.url}/auth/login/?username=$email&password=$password',
  static String login = "auth/login/";
  static String updateUser = "auth/update/";
  static String emailChecker = "auth/email/login/";
  static String refreshToken = "auth/refresh/";

  // Groceries
  static String searchGrocery = "grocery/search/";
  static const String getGrocery = "grocery/";
  static const String createGroceryOrder = "grocery/create_order/";
  static const String updateGroceryOrder = "grocery/update_order/";
  static const String getGroceryOrder = "grocery/orders/";
  static const String getSingleGroceryOrder = "grocery/order/";
  static const String deleteGroceryOrder = "grocery/delete_order/";

  // Meal plan
  static String createMealplan = "/mealplan/create/";
  static String createMealplanAI = "mealplan/AI/create/";
  static String updateMealplan = "mealplan/update/";
  static String retrieveMealplan = "mealplan/mealplan/";
  static String deleteMealplan = "mealplan/delete/";
  static String getMealplanDates = "mealplan/mealplans/dates/";

  // Recipe
  static String getRecipes = "recipes/recipes";
  static String addRecipeUrl(String url) => "recipes/generate/$url";

// Onbording
  static String submitSurvey = "onboarding/submit_surver";
  static String submitSurveyAuth = "onboarding/submit_surver";
  static String getSurvey = "onboarding/response";
  static String updateSurvey = "onboarding/update";
}
