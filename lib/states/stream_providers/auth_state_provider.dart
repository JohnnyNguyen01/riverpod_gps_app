import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/repositories/auth_repo_impl.dart';

final authStateChangesProvider = StreamProvider.autoDispose((ref) {
  final _authRepoImpl = ref.read(firebaseAuthProvider);
  return _authRepoImpl.getAuthStateStream();
});
