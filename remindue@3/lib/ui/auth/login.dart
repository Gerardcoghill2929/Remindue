import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:remindue/services/api_service.dart';
import 'package:remindue/ui/auth/register.dart';
import 'package:remindue/ui/home_page.dart';
import 'package:remindue/ui/theme.dart';
import 'package:remindue/ui/widgets/button.dart';
import 'package:remindue/ui/widgets/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> onLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (_email.text.isEmpty) {
      Get.snackbar('Login Failed', 'Email is required');
      return;
    }

    if (_password.text.isEmpty) {
      Get.snackbar('Login Failed', 'Password is required');
      return;
    }

    final result = await ApiService.getUserByEmail(_email.text);

    if (result['success'] != true) {
      final String message =
          result['message']?.toString() ?? 'User does not exist';
      Get.snackbar('Login Failed', message);
      return;
    }

    final dynamic rawUserId = result['userId'];
    final int? userId = rawUserId;

    if (userId == null) {
      Get.snackbar('Login Failed', 'User ID missing from server response');
      return;
    }

    print(result['password'].toString());

    String password = result['password'].toString();

    if (password != _password.text) {
      Get.snackbar('Login Failed', 'Invalid username and password');
      return;
    }

    await prefs.setInt('user_id', userId);

    Get.to(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: Row(
                        children: [
                          Text(
                            "Login to you account to continue",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.white.withValues(alpha: 0.5),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    MyInputField(
                      title: "Email",
                      hint: "",
                      isColorBackground: true,
                      ignoreDarkMode: true,
                      controller: _email,
                    ),
                    MyInputField(
                      title: "Password",
                      hint: "",
                      obscureText: true,
                      isColorBackground: true,
                      ignoreDarkMode: true,
                      controller: _password,
                    ),
                    SizedBox(height: 12),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 22),
                      width: double.infinity,
                      child: MyButton(
                        label: "Login",
                        onTap: () => onLogin(),
                        styleType: "secondary",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => Register());
                            },
                            child: Text(
                              "Register Here",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
