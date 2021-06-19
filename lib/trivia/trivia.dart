import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:chat_app/resources.dart';
import 'package:chat_app/trivia/trivia_loading.dart';

var triviaTimer;

// Trivia Home Screen
class Trivia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => AdaptiveBuilder(widget),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0d324d), Color(0xff7f5a83)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Trivia!',
                      style: GoogleFonts.ubuntu(
                        fontSize: 70.0,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    RelativeSpacer(context, 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: -math.pi / 24,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 35.0),
                              ),
                              Text(
                                '?',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 250.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.rotate(
                          angle: math.pi / 36,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 35.0),
                                ),
                                Text(
                                  '?',
                                  style: GoogleFonts.luckiestGuy(
                                    fontSize: 250.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    RelativeSpacer(context, 15.0),
                    StartGameButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

// Button To Begin Game
class StartGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'START GAME',
            style: GoogleFonts.roboto(
              fontSize: 27.0,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TriviaLoading(),
        ),
      ),
    );
  }
}

// Individual Question Screen
class TriviaGame extends StatefulWidget {
  final response, index;
  TriviaGame([this.response, this.index]);
  @override
  _TriviaGameState createState() => _TriviaGameState(this.response, this.index);
}

class _TriviaGameState extends State<TriviaGame> {
  final response, index;
  var body;
  int counter = 9;
  List answers = [];
  _TriviaGameState(this.response, this.index) {
    body = jsonDecode(this.response.body)['results'];
    answers = body[this.index]['incorrect_answers'] +
        [body[this.index]['correct_answer']];
    answers.shuffle();
    print(answers);
  }

  void startTimer() {
    triviaTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (counter > 0) {
        setState(() {
          counter--;
        });
      } else {
        triviaTimer.cancel();
      }
    });
  }

  Color? diffultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.greenAccent;
      case 'medium':
        return Colors.amberAccent[100];
      default:
        return Colors.redAccent[100];
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => AdaptiveBuilder(widget),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0d324d), Color(0xff7f5a83)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '$counter',
                        style: GoogleFonts.roboto(
                          fontSize: 40.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.white),
                RelativeSpacer(context, 4.0),
                Text(
                  "Question ${this.index + 1} of 10 (${body[this.index]['category'].replaceAll('Entertainment: ', '')})",
                  style: GoogleFonts.ubuntu(fontSize: 50.0),
                  textAlign: TextAlign.center,
                ),
                RelativeSpacer(context, 4.0),
                RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Text(
                            'Difficulty: ',
                            style: GoogleFonts.montserrat(
                              fontSize: 40.0,
                              letterSpacing: 4.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        WidgetSpan(
                          child: Text(
                            '${toBeginningOfSentenceCase(body[this.index]['difficulty'])}',
                            style: GoogleFonts.montserrat(
                              fontSize: 40.0,
                              letterSpacing: 4.0,
                              color:
                                  diffultyColor(body[this.index]['difficulty']),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center),
                RelativeSpacer(context, 4.0),
                Divider(color: Colors.white),
                RelativeSpacer(context, 4.0),
                Text(HtmlUnescape().convert(body[this.index]['question']),
                    style: GoogleFonts.montserrat(
                      fontSize: 30.0,
                      letterSpacing: 3.0,
                    ),
                    textAlign: TextAlign.center),
                RelativeSpacer(context, 4.0),
                ...[
                  for (var answer in answers)
                    QuestionButton(answer, body, index),
                  RelativeSpacer(context, 4.0)
                ],
                Divider(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}

// Button For Individual Questions
class QuestionButton extends StatefulWidget {
  final answer, body, index;
  QuestionButton(this.answer, this.body, this.index);
  _QuestionButtonState createState() =>
      _QuestionButtonState(this.answer, this.body, this.index);
}

class _QuestionButtonState extends State<QuestionButton> {
  final answer, body, index;
  _QuestionButtonState(this.answer, this.body, this.index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(HtmlUnescape().convert(answer.toString()),
                  style: GoogleFonts.montserrat(
                    fontSize: 30.0,
                    letterSpacing: 4.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
            ),
            margin: const EdgeInsets.all(15.0),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ResultPage(
                answer ==
                    HtmlUnescape().convert(body[this.index]['correct_answer']),
              );
            },
          ),
        );
      },
    );
  }
}

// Answer Result Screen
class ResultPage extends StatelessWidget {
  final bool isCorrect;
  ResultPage(this.isCorrect);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => AdaptiveBuilder(widget),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0d324d), Color(0xff7f5a83)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Text((isCorrect) ? 'Correct!' : 'Incorrect!',
                    style: GoogleFonts.ubuntu(
                      fontSize: 80.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center),
                Container(
                  height: 700,
                  child: (isCorrect)
                      ? RiveAnimationController('animations/rightanswer.riv')
                      : RiveAnimationController('animations/wronganswer.riv'),
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class TimeOutPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container();
  }
}
