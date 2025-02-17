import 'package:flutter/foundation.dart' show debugPrint, kReleaseMode;
import 'package:flutter/material.dart' show runApp, WidgetsFlutterBinding;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;

import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'firebase_setup.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kReleaseMode) {
    debugPrint = (message, {int? wrapWidth}) {};
  }

  await firebaseSetup();

  registerInstances();

  runApp(const AppWidget());
}
