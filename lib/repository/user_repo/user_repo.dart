// ignore_for_file: non_constant_identifier_names

abstract class UserRepo {
  Future<void> deleteUser();
  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> user, String token);
  Future<Map<String, dynamic>> signIn(
      {required String email, required String password});
  Future<Map<String, dynamic>> verifyEmail(
      {required String pin, required String email});
  Future<Map<String, dynamic>> verifyResetToken(
      {required String token, required String email});
  Future<Map<String, dynamic>> resendOTP(
      {required String email, required String password});
  Future<void> logout();
  Future<Map> singUp(Map<String, dynamic> user);
  Future<Map> changePassword(
    Map<String, dynamic> Data,
  );
  Future<Map<String, dynamic>> forgotPassword(
    String email,
  );
  Future<Map<String, dynamic>> setPassword({
    required String password,
    required String email,
  });
  Future<Map<String, dynamic>> deleteAccount(String password);
  Future<Map<String, dynamic>> resetPassword(
    Map<String, dynamic> Data,
  );
  Future<Map<String, dynamic>> getUserprofile();
  Future<Map<String, dynamic>> googleSingUp(String user);
  Future<Map<String, dynamic>> appleSingUp(String user);

  // Future<Map<String, dynamic>> submitSurvey();

  // Future<Map> updateUser(Map<String, dynamic> user);
}
