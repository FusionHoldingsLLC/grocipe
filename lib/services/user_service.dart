import 'package:grocipe/app/locator/locator.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/user.dart';
import 'package:stacked/stacked.dart';

class UserService with ListenableServiceMixin {
  final _user = ReactiveValue<User?>(null);
  final _hiveFunction = locator<HiveFunction>();

  UserService() {
    listenToReactiveValues([_user]);
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _user.value = _hiveFunction.user;
    notifyListeners();
  }

  User? get user => _user.value;

  Future setUserData(User? user) async {
    if (user == null) return;
    await _hiveFunction.saveUserData(user);
    notifyListeners();
  }

  Future logOut() async {
    await _hiveFunction.clearSession();
    notifyListeners();
  }
}
