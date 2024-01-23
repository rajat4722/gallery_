import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gallery_/screens/gallery.dart';

void main() {
  // STATUS BAR COLOR
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Color(0xff6a0000),
  // ));

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Future.delayed(const Duration(seconds: 1)).then(
      (value) => FlutterNativeSplash.remove(),
    );
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GalleryScreen(),
      ),
    );
  });
}
