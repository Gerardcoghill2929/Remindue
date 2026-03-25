import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindue/models/task.dart';
import 'package:remindue/services/theme_services.dart';
import 'package:remindue/services/notification_services.dart';
import 'package:intl/intl.dart';
import 'package:remindue/ui/theme.dart';
import 'package:remindue/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'add_task_bar.dart';
import 'package:remindue/controllers/task_controller.dart';
import 'package:remindue/ui/widgets/task_tile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:remindue/services/web_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:remindue/ui/edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.find<TaskController>();
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.InitializationNotification();
    notifyHelper.requestIOSPermissions();
    if (kIsWeb) {
      WebNotificationService.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  Expanded _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print(_taskController.taskList.length);
            Task task = _taskController.taskList[index];
            print(task.toJson());

            if (task.repeat == "Daily") {
              try {
                DateTime date = DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat("HH:mm").format(date);
                DateTime now = DateTime.now();
                DateTime scheduledTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  date.hour,
                  date.minute,
                );

                if (kIsWeb) {
                  WebNotificationService.schedule(
                    scheduledTime,
                    task.title ?? "Task Reminder",
                    task.note ?? "",
                  );
                }

                notifyHelper.scheduleNotification(
                  int.parse(myTime.split(":")[0]),
                  int.parse(myTime.split(":")[1]),
                  task,
                );
              } catch (e) {
                print("Error scheduling daily notification: $e");
              }

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1375),
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Task Tapped");
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task: task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (task.repeat == "Weekly" || task.repeat == "Monthly") {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1375),
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Task Tapped");
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task: task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (task.date == DateFormat('yyyy-MM-dd').format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1375),
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Task Tapped");
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task: task),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4.0),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.32
            : MediaQuery.of(context).size.height * 0.40,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),

            task.isCompleted == 1
                ? Container()
                : _buttomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryColor,
                    context: context,
                  ),

            SizedBox(height: 10),

            _buttomSheetButton(
              label: "Edit Task",
              onTap: () async {
                Get.back();
                await Get.to(() => EditTaskPage(task: task));
                _taskController.getTasks();
              },
              clr: Colors.orange,
              context: context,
            ),

            SizedBox(height: 10),

            _buttomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                _taskController.getTasks();
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),

            SizedBox(height: 20),

            _buttomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.grey[300]!,
              isClose: true,
              context: context,
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buttomSheetButton({
    required String label,
    required VoidCallback? onTap,
    required Color clr,
    bool isClose = false,
    BuildContext? context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context!).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          daysCount: 1825,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryColor,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today", style: headingStyle),
              ],
            ),
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        "Dashboard",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? "Light Mode Activated"
                : "Dark Mode Activated",
          );
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage("images/Profile.png"),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
