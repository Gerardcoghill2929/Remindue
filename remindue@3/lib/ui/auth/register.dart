import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:remindue/services/api_service.dart';
import 'package:remindue/ui/auth/login.dart';
import 'package:remindue/ui/theme.dart';
import 'package:remindue/ui/widgets/button.dart';
import 'package:remindue/ui/widgets/input_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  Future<void> register() async {
    print('Register button clicked');
    if (_username.text.isEmpty) {
      Get.snackbar('Register Failed', 'Username is required');
      return;
    }

    if (_email.text.isEmpty) {
      Get.snackbar('Register Failed', 'Email is required');
      return;
    }

    if (_password.text.isEmpty) {
      Get.snackbar('Register Failed', 'Password is required');
      return;
    }

    if (_password.text != _confirmPassword.text) {
      Get.snackbar('Register Failed', 'Password doesn not match');
      return;
    }

    final result = await ApiService.createUser(
      _username.text,
      _email.text,
      _password.text,
    );

    final bool isSuccess = result['success'] == true;
    if (isSuccess) {
      Get.snackbar('Register Success', 'Welcome to Remindue!');
      Get.to(() => Login());
    } else {
      final String message =
          result['message']?.toString() ?? 'Registration failed';
      Get.snackbar('Register Failed', message);
    }
  }

  @override
  void dispose() {
    _email.dispose(); // always dispose controllers
    super.dispose();
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
                          "Welcome to ReminDue!",
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
                            "Create an account to continue",
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
                      title: "Username",
                      hint: "",
                      isColorBackground: true,
                      ignoreDarkMode: true,
                      controller: _username,
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
                    MyInputField(
                      title: "Confirm Password",
                      hint: "",
                      obscureText: true,
                      isColorBackground: true,
                      ignoreDarkMode: true,
                      controller: _confirmPassword,
                    ),
                    SizedBox(height: 12),

                    Container(
                      margin: EdgeInsets.only(top: 22),
                      width: double.infinity,
                      child: MyButton(
                        label: "Register",
                        onTap: () => register(),
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
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => Login());
                            },
                            child: Text(
                              "Login Here",
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
