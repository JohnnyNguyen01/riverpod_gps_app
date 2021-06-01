import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'google_map/home_map.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  static Route route() => PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomeMap(),
        ],
      ),
    );
  }
}
