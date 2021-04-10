import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chat_app/trivia/trivia.dart';

var loadingAnimationOptions = [
  SpinKitChasingDots(color: Colors.white, size: 80.0),
  SpinKitCubeGrid(color: Colors.white, size: 80.0),
  SpinKitDoubleBounce(color: Colors.white, size: 80.0),
  SpinKitFadingCube(color: Colors.white, size: 80.0),
  SpinKitFadingFour(color: Colors.white, size: 80.0),
  SpinKitFoldingCube(color: Colors.white, size: 80.0),
  SpinKitRotatingCircle(color: Colors.white, size: 80.0),
  SpinKitSquareCircle(color: Colors.white, size: 80.0)
];

class TriviaLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: TriviaLoading(),
        theme: ThemeData(
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity));
  }
}

class TriviaLoading extends StatefulWidget {
  @override
  _TriviaLoadingState createState() => _TriviaLoadingState();
}

class _TriviaLoadingState extends State<TriviaLoading> {
  Future<void> getData() async {
    var queryParameters = {'type': 'multiple', 'amount': '10'};
    var uri = Uri.https('opentdb.com', '/api.php', queryParameters);
    http.Response response = await http.get(uri);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TriviaGame(response, 0)));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff0d324d), Color(0xff7f5a83)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Center(
                child: loadingAnimationOptions[
                    Random().nextInt(loadingAnimationOptions.length)])));
  }
}
