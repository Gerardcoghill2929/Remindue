import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:remindue/db/db_helper.dart';
import 'package:remindue/models/task.dart';
import 'package:remindue/controllers/task_controller.dart';
import 'package:remindue/ui/all_tasks_page.dart';
import 'package:remindue/ui/edit_task_page.dart';
import 'package:remindue/ui/theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final TaskController _taskController = Get.find<TaskController>();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Map<String, dynamic>> _allTasks = [];
  List<Map<String, dynamic>> _selectedTasks = [];
  int _calendarKey = 0; // Add key for forcing calendar refresh

  late Worker _taskWorker;

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
    _updateTasksFromController();

    _taskWorker = ever(_taskController.taskList, (_) {
      if (mounted) {
        _updateTasksFromController();
      }
    });
  }

  @override
  void dispose() {
    _taskWorker.dispose();
    super.dispose();
  }

  void _updateTasksFromController() {
    if (mounted) {
      setState(() {
        _allTasks = _taskController.taskList
            .map((task) => task.toJson())
            .toList();
        _calendarKey++; // force calendar marker refresh
        _filterTasks(_selectedDay);
      });
    }
  }

  Color _getTaskColor(int? colorIndex) {
    switch (colorIndex) {
      case 0:
        return primaryColor;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return primaryColor;
    }
  }

  Future<void> loadTasks() async {
    final tasks = await DBHelper.query();

    setState(() {
      _allTasks = tasks;
      _calendarKey++; // Increment key to force calendar refresh
    });

    _filterTasks(_selectedDay);
  }

  void _filterTasks(DateTime date) {
    if (mounted) {
      setState(() {
        _selectedTasks = _allTasks.where((task) {
          try {
            DateTime taskDate = DateTime.parse(task['date']);
            return isSameDay(taskDate, date);
          } catch (e) {
            return false;
          }
        }).toList();
      });
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _allTasks.where((task) {
      try {
        DateTime taskDate = DateTime.parse(task['date']);
        return isSameDay(taskDate, day);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllTasksPage()),
              );
              // ensure calendar recalc after coming back
              _updateTasksFromController();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          TableCalendar(
            key: ValueKey(_calendarKey), // Add key to force refresh
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              _filterTasks(selectedDay);
            },
          ),

          const SizedBox(height: 10),

          Expanded(
            child: _selectedTasks.isEmpty
                ? const Center(child: Text("No tasks for this day"))
                : ListView.builder(
                    itemCount: _selectedTasks.length,
                    itemBuilder: (context, index) {
                      var taskMap = _selectedTasks[index];

                      Task task = Task(
                        id: taskMap['id'],
                        title: taskMap['title'],
                        note: taskMap['note'],
                        date: taskMap['date'],
                        startTime: taskMap['startTime'],
                        endTime: taskMap['endTime'],
                        remind: taskMap['remind'],
                        repeat: taskMap['repeat'],
                        color: taskMap['color'],
                        isCompleted: taskMap['isCompleted'],
                      );

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: _getTaskColor(task.color),
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            task.title ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            task.note ?? '',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () async {
                            await Get.to(() => EditTaskPage(task: task));
                            await loadTasks();
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () async {
                              if (task.id != null) {
                                await _taskController.deleteTask(task);
                                _updateTasksFromController();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
