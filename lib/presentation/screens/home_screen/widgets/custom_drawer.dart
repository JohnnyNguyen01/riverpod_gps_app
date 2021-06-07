import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_tracker_youtube/states/user_state_notifier.dart';

import '../../screens.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('PlaceHolder title'),
          ),
          ElevatedButton(
            onPressed: () {
              //todo: move to custom controller class.
              watch(userStateProvider.notifier).logoutUser();
              Navigator.of(context).popAndPushNamed(SignupScreen.routeName);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
