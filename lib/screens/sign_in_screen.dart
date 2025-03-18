import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/my_button.dart';
import 'package:chat_app/widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  late String email, password;
  bool isLoading = false; // استخدام Shimmer عند تحميل البيانات

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
          onPressed: () {
            Navigator.pop(context);
          },
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
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        hintText: 'Enter your password',
                        onChanged: (value) {
                          password = value;
                        },
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 30),
                      MyButton(
                        color: const Color.fromARGB(255, 32, 115, 184),
                        title: 'تسجيل دخول',
                        onPressed: () async {
                          setState(() {
                            isLoading =
                                true; // تفعيل Shimmer أثناء تحميل البيانات
                          });

                          try {
                            final userCredential = await _auth
                                .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                            if (userCredential.user != null) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.chatScreen,
                              );
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              isLoading = false; // إيقاف تأثير Shimmer
                            });
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
