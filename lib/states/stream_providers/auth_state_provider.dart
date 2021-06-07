import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/domain/repositories/auth_repo_impl.dart';

final authStateChangesProvider = StreamProvider.autoDispose((ref) async* {
  final _authRepoImpl = ref.read(firebaseAuthProvider);
  final authStream = _authRepoImpl.getAuthStateStream();

  for (final user in await authStream.toList()) {
    yield user;
  }
});
