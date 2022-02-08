import 'dart:async';
import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_test/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {

  //Zoned Errors
  //Not all errors are caught by Flutter. Sometimes, errors are instead caught by Zones.
  //A common case were FlutterError would not be enough is when an exception happen inside the onPressed of a button:


  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    var random = Random();
    var userid = random.nextInt(20000);
    analytics.setUserId(id: '12345');

    // Pass all uncaught errors from the framework to Crashlytics.
    //it will automatically catch all errors that are thrown within the Flutter framework.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    //To add user IDs to your reports, assign each user with a unique ID. This can be an ID number, token or hashed value:
    //To reset a user ID (e.g. when a user logs out), set the user ID to an empty string.
    FirebaseCrashlytics.instance.setUserIdentifier("12345");

    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/second': (context) => const SecondScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    FirebaseCrashlytics.instance.setCustomKey('clicked_on', 'increment');
    // FirebaseCrashlytics.instance.crash();

    // await FirebaseAnalytics.instance
    //     .logEvent(name: 'clicked_plus_button', parameters: {
    //   'current_number': _counter,
    // });
    Navigator.pushNamed(context, '/second');
  }

  void _decrementCounter() async {
    // setState(() {
    //   _counter--;
    // });

    FirebaseCrashlytics.instance.setCustomKey('clicked_on', 'decrement');
    // FirebaseCrashlytics.instance.crash();
    // await FirebaseAnalytics.instance
    //     .logEvent(name: 'clicked_minus_button', parameters: {
    //   'current_number': _counter,
    // });

    Navigator.pushNamed(context, '/second');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'home_page');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'dec',
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
