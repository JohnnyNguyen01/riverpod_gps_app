import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/models/models.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserSigningIn extends UserState {
  const UserSigningIn();
}

class UserSignedIn extends UserState {
  final User user;
  const UserSignedIn(this.user);
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, User>((ref) {
  return UserStateNotifier();
});

class UserStateNotifier extends StateNotifier<User> {
  //todo refactor below
  UserStateNotifier() : super(const User(email: "", userName: ""));

  //todo: utilise loading state as well
  void loginuser({required User user}) {
    state = user;
  }
}
