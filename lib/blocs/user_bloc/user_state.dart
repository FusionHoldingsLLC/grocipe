part of 'user_bloc.dart';

@immutable
sealed class UserState {
  final User? user;
  UserState({this.user});
}

final class UserInitial extends UserState {
  final User? user;
  UserInitial({this.user});
}

class UserProcessing extends UserState {
  final bool isSignup;
  final bool isLoginIN;
  final bool isCreating;
  final bool isFetching;
  final bool isDeleting;
  final bool isChangePassword;
  final bool isVeerifying;
  final bool isVeerifyingToken;
  final bool isUpdating;
  final bool isSetPassword;
  final bool isForgotPassword;
  final User? user; 

  UserProcessing(
      {this.isCreating = false,
      this.isDeleting = false,
      this.isFetching = false,
      this.isUpdating = false,
      this.isVeerifyingToken = false,
      this.isSetPassword = false,
      this.isLoginIN = false,
      this.isSignup = false,
      this.isChangePassword = false,
      this.isForgotPassword = false,
      this.isVeerifying = false,
      this.user});
}

class UserError extends UserState {
  final String message;
  final User? user; // Keep showing previous recipes even on error

  UserError({required this.message, this.user});
}

class userLoaded extends UserState {
  final User? user;
  final bool isExternal;
  final String message;
  userLoaded(
      {required this.user, required this.message, this.isExternal = false});
}
