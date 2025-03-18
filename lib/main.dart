import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:chat_app/routes/on_generate_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          _auth.currentUser != null
              ? AppRoutes.chatScreen
              : AppRoutes.welcomeScreen,

      // initialRoute: AppRoutes.welcomeScreen,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
    );
  }
}
