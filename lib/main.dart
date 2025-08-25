// import 'package:cargo_objets/controllers/api_controller.dart';
// import 'package:cargo_objets/controllers/auth_controller.dart';
// import 'package:cargo_objets/services/api_service.dart';
// import 'package:cargo_objets/utils/app_theme.dart';
// import 'package:cargo_objets/views/splash_screen.dart';
import 'package:cargoapp/controllers/api_controller.dart';
import 'package:cargoapp/controllers/auth_controller.dart';
import 'package:cargoapp/services/api_service.dart';
import 'package:cargoapp/utils/app_theme.dart';
import 'package:cargoapp/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize dependencies
  Get.put(ApiService());
  Get.put(AuthController());
  Get.put(ApiController());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CRUD App',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}