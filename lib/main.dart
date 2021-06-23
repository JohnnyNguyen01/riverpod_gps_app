import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/home_screen/home_screen.dart';
import 'package:pet_tracker_youtube/presentation/screens/screens.dart';
import 'package:pet_tracker_youtube/routes/custom_router.dart';
import 'package:pet_tracker_youtube/states/stream_providers/auth_state_provider.dart';
import 'package:pet_tracker_youtube/utils/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //Used to determine whether we should navigate to homeScreen or Signup screen
    //depending on whether a user is signed in or not.
    final authStateStream = watch(authStateChangesProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: Themes.primaryTheme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute:
          //todo: put back in after finished developing
          authStateStream.data?.value?.uid == null
              ? SignupScreen.routeName
              : HomeScreen.routeName,
    );
  }
}
