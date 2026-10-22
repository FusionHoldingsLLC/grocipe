part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class SignUpEvent extends UserEvent {
  final String? f_name;
  final String? l_name;
  final String email;
  final String password;
  final String? image;

  SignUpEvent(
      {this.f_name,
      this.l_name,
      required this.email,
      required this.password,
      this.image});
}

final class UpdateUserEvent extends UserEvent {
  final String f_name;
  final String l_name;
  final String email;
  final String image;
  final bool isOnline;
  UpdateUserEvent(
      {required this.f_name,
      required this.l_name,
      required this.isOnline,
      required this.email,
      required this.image});
}

final class VerfiyEvent extends UserEvent {
  final String email;
  final String token;

  VerfiyEvent({
    required this.email,
    required this.token,
  });
}

final class SigninEvent extends UserEvent {
  final String email;
  final String password;

  SigninEvent({
    required this.email,
    required this.password,
  });
}

final class RestoreUserEvent extends UserEvent {
  final User user;

  RestoreUserEvent({
    required this.user,
  });
}

final class ClearUserEvent extends UserEvent {}

final class ChnageUserPasswrodEvent extends UserEvent {
  final String oldPassword;
  final String newPassword;

  ChnageUserPasswrodEvent(
      {required this.oldPassword, required this.newPassword});
}

final class DeleteAccount extends UserEvent {
  final String password;

  DeleteAccount({required this.password});
}

final class ForotPasswordEvent extends UserEvent {
  final String email;

  ForotPasswordEvent({required this.email});
}

final class VerifyResetPassword extends UserEvent {
  final String email;
  final String token;

  VerifyResetPassword({required this.email, required this.token});
}

final class SetPasswordEvent extends UserEvent {
  final String email;
  final String password;

  SetPasswordEvent({required this.email, required this.password});
}

final class GoogleSignInEvent extends UserEvent {
  final String id;

  GoogleSignInEvent({
    required this.id,
  });
}

final class AppleSignInEvent extends UserEvent {
  final String id;

  AppleSignInEvent({
    required this.id,
  });
}
