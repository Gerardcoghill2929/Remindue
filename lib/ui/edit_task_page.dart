import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remindue/controllers/task_controller.dart';
import 'package:remindue/models/task.dart';
import 'package:remindue/ui/theme.dart';
import 'package:remindue/ui/widgets/button.dart';
import 'package:remindue/ui/widgets/input_field.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TaskController _taskController = Get.find<TaskController>();

  late TextEditingController _titleController;
  late TextEditingController _noteController;

  late DateTime _selectedDate;
  late String _startTime;
  late String _endTime;
  late int _selectedRemind;
  late String _selectedRepeat;
  late int _selectedColor;

  List<int> remindList = [5, 10, 15, 20];
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title ?? "");
    _noteController = TextEditingController(text: widget.task.note ?? "");
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.task.date!);
    _startTime = widget.task.startTime ?? "09:00 AM";
    _endTime = widget.task.endTime ?? "09:30 AM";
    _selectedRemind = widget.task.remind ?? 5;
    _selectedRepeat = widget.task.repeat ?? "None";
    _selectedColor = widget.task.color ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit Task", style: headingStyle),
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
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: _getDateFromUser,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MyInputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: true),
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MyInputField(
                    title: "End Time",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: false),
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
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
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                style: subtitleStyle,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
                items: remindList.map((int value) {
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
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                iconSize: 32,
                elevation: 4,
                style: subtitleStyle,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
                items: repeatList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _colorPallete(),
                MyButton(label: "Update Task", onTap: _updateTask),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask() async {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
      );
      return;
    }

    Task updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: widget.task.isCompleted ?? 0,
    );

    await _taskController.updateTask(updatedTask);
    Get.back();
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                      ? pinkClr
                      : yellowClr,
                  child: _selectedColor == index
                      ? const Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await _showTimePicker(
      isStartTime ? _startTime : _endTime,
    );

    if (pickedTime == null) return;

    final now = DateTime.now();
    final formattedTime = DateFormat.jm().format(
      DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );

    setState(() {
      if (isStartTime) {
        _startTime = formattedTime;
      } else {
        _endTime = formattedTime;
      }
    });
  }

  Future<TimeOfDay?> _showTimePicker(String time) async {
    DateTime parsedTime = DateFormat.jm().parse(time);

    return showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute),
    );
  }
}
