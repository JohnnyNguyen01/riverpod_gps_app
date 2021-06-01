import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/presentation/screens/screens.dart';
import 'package:pet_tracker_youtube/routes/custom_router.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Themes.primaryTheme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: SignupScreen.routeName,
    );
  }
}
