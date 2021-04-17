import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

class RiveAnimationController extends StatefulWidget {
  final fileName;
  RiveAnimationController(this.fileName);

  @override
  _RiveAnimationControllerState createState() =>
      _RiveAnimationControllerState(this.fileName);
}

class _RiveAnimationControllerState extends State<RiveAnimationController> {
  final fileName;
  _RiveAnimationControllerState(this.fileName);
  var animation;

  @override
  void initState() {
    loadFile();
    super.initState();
  }

  void loadFile() async {
    rootBundle.load(fileName).then((data) async {
      var file = RiveFile.import(data);
      var artboard = file.mainArtboard;
      artboard.addController(SimpleAnimation('go'));
      setState(() => animation = artboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Rive(artboard: animation, fit: BoxFit.cover));
  }
}
