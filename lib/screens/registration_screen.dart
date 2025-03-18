import 'dart:developer';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/widgets/my_button.dart';
import 'package:chat_app/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '', password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/livechat.png'),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              isLoading
                  ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      MyTextField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter your email',
                        onChanged: (value) => email = value,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        hintText: 'Enter your password',
                        onChanged: (value) => password = value,
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 30),
                      MyButton(
                        color: const Color.fromARGB(255, 199, 153, 3),
                        title: 'تسجيل',
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final user = await _auth
                                .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                            if (user.user != null && mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.chatScreen,
                              );
                            }
                          } catch (e) {
                            log(e.toString());
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
