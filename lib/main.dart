import 'package:flutter/material.dart';
import 'package:geo_maps/bloc/app_bloc.dart';
import 'package:geo_maps/bloc/bloc_provider.dart';
import 'package:geo_maps/pages/camera_page.dart';
import 'package:geo_maps/pages/home_page_maps.dart';
import 'package:geo_maps/pages/login_page.dart';
import 'package:geo_maps/pages/splash_page.dart';

void main() => runApp(HackApp());

class HackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<AppBLoC>(
      bloc: AppBLoC(),
      child: MaterialApp(
        title: "HackApp",
        home: SplashPage(),
        routes: {
          '/splash': (BuildContext _) => SplashPage(),
          '/home': (BuildContext _) => HomePageMaps(),
          '/camera': (BuildContext _) => CameraPage(),
          '/login': (BuildContext _) => LoginPage()
        },
      ),
    );
  }
}
