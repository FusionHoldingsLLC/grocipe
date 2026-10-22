import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/user.dart';

class ProfileProvider extends StateNotifier<User?> {
  final Ref ref;
  User? user;
  ProfileProvider(this.ref, this.user) : super(user);

  HiveFunction get storage => ref.read(localStorageService);

  Future setUserData(User? user) async {
    if (user == null) return;
    storage.saveUserData(user);
    state = user;
    return;
  }

  Future logOut() async {
    await storage.clearSession();
    state = null;
    return;
  }
}

final profileProvider = StateNotifierProvider<ProfileProvider, User?>(
  (ref) {
    final storage = ref.watch(localStorageService);
    User? user = storage.user;
    return ProfileProvider(ref, user);
  },
);
