import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _clicked = false;

  rive.SMITrigger? _trigger_blink_n_shrink;
  rive.SMITrigger? _trigger_blink_red;

  void _onRiveInit(rive.Artboard artboard) {
    var blinkNShrinkController = rive.StateMachineController.fromArtboard(
        artboard, 'run_blink_n_shrink');
    var blinkRedController =
        rive.StateMachineController.fromArtboard(artboard, 'run_blink_red');
    artboard.addController(blinkNShrinkController!);
    artboard.addController(blinkRedController!);
    _trigger_blink_n_shrink = blinkNShrinkController
        .findInput<bool>('trigger_blink_n_shrink') as rive.SMITrigger;
    _trigger_blink_red = blinkRedController.findInput<bool>('trigger_blink_red')
        as rive.SMITrigger;
  }

  void _foundNew() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      _trigger_blink_n_shrink?.fire();
      _clicked = !_clicked;

      final snackBar = SnackBar(
        content: Text(
          'FOUND: ${randomSerial()}',
          textAlign: TextAlign.center,
        ),
        margin: EdgeInsets.only(bottom: 100),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withAlpha(100),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void _foundExisting() {
    setState(() {
      _trigger_blink_red?.fire();
    });
  }

  String randomSerial() {
    var ran = Random();
    const p = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
    ];
    var prefix = p[ran.nextInt(12)];
    const s = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      '*',
    ];
    var suffix = s[ran.nextInt(13)];
    var sn = ran.nextInt(99999999);
    late String rtn = '$prefix$sn$suffix';
    return rtn;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          OverflowBar(
            spacing: 8,
            overflowAlignment: OverflowBarAlignment.end,
            children: <Widget>[
              OutlinedButton(
                onPressed: _foundExisting,
                child: Icon(Icons.add_chart),
              ),
              TextButton(child: const Text('clicky'), onPressed: () {}),
              OutlinedButton(
                onPressed: _foundNew,
                child: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: Stack(children: <Widget>[
          Image(
            image: Device.isAndroid
                ? AssetImage('images/bt_dollar_tall.jpg')
                : AssetImage('images/bt_dollar.jpg'),
            fit: BoxFit.contain,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
              child: rive.RiveAnimation.asset(
                'images/bucktrace.found.animation.riv',
                onInit: _onRiveInit,
                fit: BoxFit.fill,
              )),
          // Container(color: Colors.red))
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: <Widget>[
          //       Padding(
          //           padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 120.0),
          //           child: Text('You have pushed the button this many times:',
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 background: Paint()
          //                   ..color = Colors.blue.withAlpha(80)
          //                   ..strokeWidth = 20
          //                   ..strokeJoin = StrokeJoin.round
          //                   ..strokeCap = StrokeCap.round
          //                   ..style = PaintingStyle.stroke,
          //                 color: Colors.white,
          //               )))
          //     ],
          //   )
          // ])
        ])),
        Row(
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _foundNew,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Device {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);
  static bool get isMobile => isAndroid || isIOS;
  static bool get isWeb => false;

  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isFuchsia => Platform.isFuchsia;
  static bool get isIOS => Platform.isIOS;
}
