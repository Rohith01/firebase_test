import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.setCustomKey('screen', 'second_screen');
    return SafeArea(
      child: Scaffold(
        body:  Center(
          child: ElevatedButton(child: const Text('Test Crash'),
          onPressed: _buttonClick),
        ),
      ),
    );
  }

   void _buttonClick() async {
    FirebaseCrashlytics.instance.setCustomKey('clicked_on', 'second button');
    FirebaseCrashlytics.instance.crash();
  }
}