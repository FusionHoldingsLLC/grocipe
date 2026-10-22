// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:grocipe/helper/third_party/cloudinary.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/repository/user_repo/user_implementation.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userRepoImp userRepo;

  UserBloc({required this.userRepo}) : super(UserInitial()) {
    on<SignUpEvent>(_signupEvent);
    on<UpdateUserEvent>(_updateUser);
    on<VerfiyEvent>(_verifyEvent);
    on<SigninEvent>(_signInEvent);
    on<RestoreUserEvent>(_restoreEvent);
    on<ClearUserEvent>(_clearUserEvent);
    on<ChnageUserPasswrodEvent>(_chnagePassword);
    on<DeleteAccount>(_deleteUser);
    on<ForotPasswordEvent>(_forgotPassword);
    on<VerifyResetPassword>(_verifyToken);
    on<SetPasswordEvent>(_serPassword);
    on<GoogleSignInEvent>(_googleSignIN);
    on<AppleSignInEvent>(_appleSignIn);
  }
  _appleSignIn(AppleSignInEvent event, Emitter emit) async {
    emit(UserProcessing(isLoginIN: true, user: state.user));
    try {
      Map<String, dynamic> response = await userRepo.appleSingUp(
        event.id,
      );

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['detail'] == null) {
        User user = User.fromJson(response);
        HiveFunction.insertUser(user);

        emit(
          userLoaded(
            message: "User Login Successfully",
            user: user,
            isExternal: true,
          ),
        );
      } else {
        emit(UserError(message: response['detail'], user: state.user));
      }
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _googleSignIN(GoogleSignInEvent event, Emitter emit) async {
    emit(UserProcessing(isLoginIN: true, user: state.user));
    try {
      Map<String, dynamic> response = await userRepo.googleSingUp(
        event.id,
      );

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['detail'] == null) {
        User user = User.fromJson(response);
        HiveFunction.insertUser(user);

        emit(userLoaded(
          message: "User Login Successfully",
          user: user,
          isExternal: true,
        ));
      } else {
        emit(UserError(message: response['detail'], user: state.user));
      }
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _serPassword(SetPasswordEvent event, Emitter emit) async {
    emit(UserProcessing(isSetPassword: true, user: state.user));
    try {
      Map<String, dynamic> response = await userRepo.setPassword(
          password: event.password, email: event.email);
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['status'] == false) {
        emit(UserError(message: response['message'], user: state.user));
      } else if (response['detail'] == null) {
        emit(userLoaded(message: response['message'], user: state.user));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
      print(response);
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _initialize(Emitter emit) {
    emit(UserInitial(user: state.user));
  }

  _verifyToken(VerifyResetPassword event, Emitter emit) async {
    emit(UserProcessing(isVeerifyingToken: true, user: state.user));
    try {
      Map<String, dynamic> response = await userRepo.verifyResetToken(
          token: event.token, email: event.email);
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['status'] == false) {
        emit(UserError(message: response['message'], user: state.user));
      } else if (response['detail'] == null) {
        emit(userLoaded(message: response['message'], user: state.user));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
      print(response);
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _forgotPassword(ForotPasswordEvent event, Emitter emit) async {
    emit(UserProcessing(isForgotPassword: true, user: state.user));
    try {
      Map<String, dynamic> response =
          await userRepo.forgotPassword(event.email);
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['success'] == false) {
        emit(UserError(message: response['message'], user: state.user));
      } else if (response['detail'] == null) {
        emit(userLoaded(message: response['message'], user: state.user));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _deleteUser(DeleteAccount event, Emitter emit) async {
    emit(UserProcessing(isDeleting: true, user: state.user));
    try {
      Map<String, dynamic> response =
          await userRepo.deleteAccount(event.password);
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['status'] == false) {
        emit(UserError(message: response['message'], user: state.user));
      } else if (response['detail'] == null) {
        HiveFunction.deleteAllExceptUser();
        emit(userLoaded(message: "Deleted Successfully", user: null));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
      print(response);
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _chnagePassword(ChnageUserPasswrodEvent event, Emitter emit) async {
    emit(UserProcessing(isChangePassword: true, user: state.user));
    try {
      Map<String, dynamic> response = await userRepo.changePassword(
        {
          "old_password": event.oldPassword,
          "new_password": event.newPassword,
        },
      );
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['status'] == false) {
        emit(UserError(message: response['message'], user: state.user));
      } else if (response['detail'] == null) {
        emit(userLoaded(
            message: "Changed password Successfully", user: state.user));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
      print(response);
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _clearUserEvent(ClearUserEvent event, Emitter emit) async {
    userLoaded(user: null, message: "Clear Sucessufully");
  }

  _updateUser(UpdateUserEvent event, Emitter emit) async {
    emit(UserProcessing(isUpdating: true, user: state.user));
    try {
      var image = event.isOnline == false
          ? await CloudinaryDev.uploadPicture(
              path: event.image, folder: "User", fileName: event.email)
          : event.image;
      if (image is String) {
        Map<String, dynamic> response = await userRepo.updateUser({
          "first_name": event.f_name,
          "last_name": event.l_name,
          "email": event.email,
          "profile_picture_url": image,
          "trial_start_date": DateTime.now().toIso8601String()
        }, HiveFunction.getUser().accessToken);

        if (response['detail'] is List) {
          emit(UserError(
              message: response['detail'][0]['msg'], user: state.user));
        } else if (response['detail'] == null) {
          User user = state.user!.copyWith(
            firstName: response['first_name'],
            lastName: response['last_name'],
            email: response['email'],
            role: response['role'],
            isVerified: response['is_verified'],
            // isPremium: response['is_premium'],
            dateCreated: DateTime.parse(response['date_created']),
            dateUpdated: DateTime.parse(response['date_updated']),
            profilePictureUrl: response['profile_picture_url'],
          );
          HiveFunction.insertUser(user);
          emit(userLoaded(message: "User Created Successfully", user: user));
        } else {
          emit(UserError(message: response['detail'], user: state.user));
        }
        print(response);
      } else {
        UserError(message: "Error Uploading Image", user: state.user);
      }
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _signupEvent(SignUpEvent event, Emitter emit) async {
    emit(UserProcessing(isSignup: true, user: state.user));
    try {
      String? image;
      if (event.image != null) {
        image = await CloudinaryDev.uploadPicture(
            path: event.image!, folder: "User", fileName: event.email);
      }

      print(image);
      if (image is String || event.image == null) {
        Map<String, dynamic> response = await userRepo.singUp({
          "first_name": event.f_name ?? "",
          "last_name": event.l_name ?? "",
          "email": event.email,
          "password": event.password,
          "profile_picture_url": image ?? "",
          "role": "Member",
          "trial_start_date": DateTime.now().toIso8601String(),
          "external_platform": false
        });
        print(response);

        if (response['detail'] is List) {
          emit(UserError(
              message: response['detail'][0]['msg'], user: state.user));
        } else if (response['detail'] == null) {
          emit(userLoaded(
              message: "User Created Successfully", user: state.user));
        } else {
          emit(UserError(message: response['detail'], user: state.user));
        }
        print(response);
      } else {
        UserError(message: "Error Uploading Image", user: state.user);
      }
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _restoreEvent(RestoreUserEvent event, Emitter emit) async {
    emit(userLoaded(message: "User Restoreed", user: event.user));
  }

  _verifyEvent(VerfiyEvent event, Emitter emit) async {
    emit(UserProcessing(isVeerifying: true, user: state.user));
    try {
      Map<String, dynamic> response =
          await userRepo.verifyEmail(email: event.email, pin: event.token);
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['detail'] == null) {
        emit(userLoaded(
            message: "User Verified Successfully", user: state.user));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
      print(response);
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }

  _signInEvent(SigninEvent event, Emitter emit) async {
    emit(UserProcessing(isLoginIN: true, user: state.user));
    try {
      Map<String, dynamic> response =
          await userRepo.signIn(email: event.email, password: event.password);
      print(response);

      if (response['detail'] is List) {
        emit(
            UserError(message: response['detail'][0]['msg'], user: state.user));
      } else if (response['access_token'] != null) {
        User user = User.fromJson(response);
        HiveFunction.insertUser(user);

        emit(userLoaded(message: "User Verified Successfully", user: user));
      } else if (response['detail'] != null) {
        emit(UserError(message: response['detail'], user: state.user));
      } else {
        emit(UserError(message: response['message'], user: state.user));
      }
      print(response);
    } catch (e) {
      UserError(message: "Check your network", user: state.user);
    }

    _initialize(emit);
  }
}
