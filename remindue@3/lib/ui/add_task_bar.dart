import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remindue/ui/theme.dart';
import 'package:remindue/ui/widgets/button.dart';
import 'package:remindue/ui/widgets/input_field.dart';
import 'package:remindue/models/task.dart';
import 'package:remindue/controllers/task_controller.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.find<TaskController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); //Default date
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Task", style: headingStyle),
            MyInputField(
              title: "Title",
              hint: "Enter your title",
              controller: _titleController,
            ),
            MyInputField(
              title: "Notes",
              hint: "Enter your notes",
              controller: _noteController,
            ),
            MyInputField(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                onPressed: () {
                  _getDateFromUser();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MyInputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: MyInputField(
                    title: "End Time",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            MyInputField(
              title: "Remind",
              hint: "$_selectedRemind minutes early",
              widget: DropdownButton<String>(
                value: _selectedRemind.toString(),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                style: subtitleStyle,
                underline: Container(height: 0),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
                items: remindList.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),
            MyInputField(
              title: "Repeat",
              hint: _selectedRepeat,
              widget: DropdownButton<String>(
                value: _selectedRepeat,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                style: subtitleStyle,
                underline: Container(height: 0),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
                items: repeatList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.grey)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 18.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _colorPallete(),
                MyButton(label: "Create Task", onTap: () => _validateDate()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateDate() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //Add to database
      await _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded, color: pinkClr),
      );
    }
  }

  Future<void> _addTaskToDb() async {
    int value = await _taskController.addTask(
      Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        isCompleted: 0,
      ),
    );

    print(
      "My id is "
      "$value",
    );
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                      ? pinkClr
                      : yellowClr,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            "https://cdn-icons-png.flaticon.com/512/147/147144.png",
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime!.format(context);
    if (isStartTime == true) {
      setState(() {
        _startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formatedTime;
      });
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
