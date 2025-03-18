import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcomeScreen:
        return CupertinoPageRoute(builder: (_) => const WelcomeScreen());
      case AppRoutes.registrationScreen:
        return CupertinoPageRoute(builder: (_) => const RegistrationScreen());
      case AppRoutes.signInScreen:
        return CupertinoPageRoute(builder: (_) => const SignInScreen());
      case AppRoutes.chatScreen:
        return CupertinoPageRoute(builder: (_) => const ChatScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('❌ الصفحة غير موجودة!')),
              ),
        );
    }
  }
}
