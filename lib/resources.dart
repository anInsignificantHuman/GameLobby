import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Random Animation Options For Loading Screens
var loadingAnimationOptions = [
  SpinKitChasingDots(color: Colors.white, size: 80.0),
  SpinKitCubeGrid(color: Colors.white, size: 80.0),
  SpinKitDoubleBounce(color: Colors.white, size: 80.0),
  SpinKitFadingCube(color: Colors.white, size: 80.0),
  SpinKitFadingFour(color: Colors.white, size: 80.0),
  SpinKitFoldingCube(color: Colors.white, size: 80.0),
  SpinKitRotatingCircle(color: Colors.white, size: 80.0),
  SpinKitSquareCircle(color: Colors.white, size: 80.0),
];

// Widget For Displaying Rive Animations
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
    return Rive(artboard: animation, fit: BoxFit.fitHeight);
  }
}

// Builder For Responsive Layouts
class AdaptiveBuilder extends StatelessWidget {
  final Widget? child;
  AdaptiveBuilder(this.child);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      this.child,
      minWidth: 450,
      maxWidth: 2460,
      defaultScale: true,
      breakpoints: [
        ResponsiveBreakpoint.resize(600, name: MOBILE),
        ResponsiveBreakpoint.autoScale(800, name: TABLET),
        ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        ResponsiveBreakpoint.autoScale(2460, name: '4k'),
      ],
    );
  }
}

// Widget For Spacing Relative To Height
class RelativeSpacer extends StatefulWidget {
  final BuildContext context;
  final double percent;
  RelativeSpacer(this.context, this.percent);

  @override
  _RelativeSpacerState createState() => _RelativeSpacerState(context, percent);
}

class _RelativeSpacerState extends State<RelativeSpacer> {
  final BuildContext context;
  final double percent;
  _RelativeSpacerState(this.context, this.percent);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: this.percent / 100 * MediaQuery.of(context).size.height,
      ),
    );
  }
}
