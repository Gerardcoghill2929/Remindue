import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:remindue/services/api_service.dart';
import 'package:remindue/ui/auth/login.dart';
import 'package:remindue/ui/home_page.dart';
import 'package:remindue/ui/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoggedIn = false;
  bool isCheckingAuth = true;

  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    authChecker();
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');

    if (userId == null) {
      return;
    }

    final result = await ApiService.getUserById(userId);

    if (result['success'] != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _username = result['username']?.toString() ?? '';
      _email = result['email']?.toString() ?? '';
    });
  }

  Future<void> authChecker() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final bool loggedIn = userId != null;

    if (!mounted) {
      return;
    }

    setState(() {
      isLoggedIn = loggedIn;
      isCheckingAuth = false;
    });

    if (loggedIn) {
      await getUser();
    }
  }

  Future<void> onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) {
      return;
    }

    setState(() {
      isLoggedIn = false;
      _username = '';
      _email = '';
    });

    Get.to(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: isCheckingAuth
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          isLoggedIn
                              ? Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: CircleAvatar(
                                        radius: 42,
                                        backgroundImage: const NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/147/147144.png",
                                        ),
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _username.isNotEmpty
                                              ? _username
                                              : 'Unknown User',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Text(
                                          _email.isNotEmpty
                                              ? _email
                                              : 'No email',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Get.isDarkMode
                                                ? Colors.white.withValues(
                                                    alpha: 0.5,
                                                  )
                                                : Colors.black.withValues(
                                                    alpha: 0.5,
                                                  ),
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          // Container(
                          //   margin: EdgeInsets.only(top: 22),
                          //   width: double.infinity,
                          //   child: MyButton(
                          //     label: "Change Username",
                          //     onTap: () => onLogin(),
                          //     styleType: "primary",
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 22),
                            width: double.infinity,
                            child: isLoggedIn
                                ? MyButton(
                                    label: "Logout",
                                    onTap: () => onLogout(),
                                    styleType: "primary",
                                  )
                                : MyButton(
                                    label: "Login",
                                    onTap: () => Get.to(Login()),
                                    styleType: "primary",
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
