import 'package:flutter/material.dart';
import 'package:riafy_test/scoped-models/MainModel.dart';
import 'package:riafy_test/screen/BookmarkScreen.dart';
import 'package:riafy_test/screen/CommentScreen.dart';
import 'package:riafy_test/screen/DashboardScreen.dart';
import 'package:riafy_test/screen/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        model: _model,
      ),
      routes: {
        "/dash": (context) => DashboardScreen(
              model: _model,
            ),
        "/cmnt": (context) => CommentScreen(
              model: _model,
            ),
        "/bookmark": (context) => BookmarkScreen(
              model: _model,
            ),
      },
    );
  }
}
