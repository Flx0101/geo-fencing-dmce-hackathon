import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4),
        () => Navigator.of(context).pushReplacementNamed('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FlareActor(
        "assets/Rekab.flr",
        alignment: Alignment.center,
        fit: BoxFit.cover,
        animation: 'Untitled',
      ),
    );
  }
}
