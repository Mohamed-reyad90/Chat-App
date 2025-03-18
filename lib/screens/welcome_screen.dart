import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/livechat.png')),
            ),
          ),
          SizedBox(height: 30),
          MyButton(
            color: const Color.fromARGB(255, 32, 115, 184),
            title: 'تسجيل دخول',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.signInScreen);
            },
          ),
          SizedBox(height: 20),
          MyButton(
            color: const Color.fromARGB(255, 199, 153, 3),
            title: 'تسجيل جديد',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.registrationScreen);
            },
          ),
        ],
      ),
    );
  }
}
