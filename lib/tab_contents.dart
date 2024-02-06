import 'package:effecient/Screens/profile.dart';
import 'package:effecient/mapScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Tab1Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: MapScreen());
  }
}

class Tab2Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tab 2 Content'));
  }
}

class Tab3Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tab 3 Content'));
  }
}

class Tab4Content extends StatelessWidget {
  final User? user;

  const Tab4Content({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Profile(user: user),
    );
  }
}
