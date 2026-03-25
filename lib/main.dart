import 'package:flutter/material.dart';
import 'package:remindue/db/db_helper.dart';
import 'package:remindue/services/theme_services.dart';
import 'package:remindue/ui/theme.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:remindue/ui/main_navagation.dart';
import 'package:get/get.dart';
import 'package:remindue/controllers/task_controller.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await DBHelper.initDb();
  }
  await GetStorage.init();
  Get.put(TaskController()); // Initialize TaskController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Remindue',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const MainNavigation(),
    );
  }
}
