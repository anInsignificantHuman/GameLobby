import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/resources.dart';
import 'package:chat_app/trivia/trivia.dart';

// MaterialApp Wrapper For TriviaLoading
class TriviaLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TriviaLoading(),
        theme: ThemeData(
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity));
  }
}

// Trivia Loading Screen
class TriviaLoading extends StatefulWidget {
  @override
  _TriviaLoadingState createState() => _TriviaLoadingState();
}

class _TriviaLoadingState extends State<TriviaLoading> {
  Future<void> getData() async {
    var queryParameters = {'type': 'multiple', 'amount': '10'};
    var uri = Uri.https('opentdb.com', '/api.php', queryParameters);
    http.Response response = await http.get(uri);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TriviaGame(response, 0)));
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
