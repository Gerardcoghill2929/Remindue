import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindue/controllers/task_controller.dart';
import 'package:remindue/models/task.dart';
import 'package:remindue/ui/theme.dart';
import 'package:remindue/ui/edit_task_page.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  final TaskController _taskController = Get.find<TaskController>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
        backgroundColor: Colors.yellow,
      ),

      body: Obx(() {
        return _taskController.taskList.isEmpty
            ? const Center(child: Text("No tasks available"))
            : ListView.builder(
                itemCount: _taskController.taskList.length,
                itemBuilder: (context, index) {
                  final Task task = _taskController.taskList[index];

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
                        task.title ?? 'No Title',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        task.date ?? 'No Date',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () async {
                        await Get.to(() => EditTaskPage(task: task));
                        // The task list will automatically update via Obx
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          _taskController.deleteTask(task);
                        },
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
