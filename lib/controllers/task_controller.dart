import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindue/models/task.dart';
import 'package:remindue/db/db_helper.dart';

class TaskController extends GetxController {
  final box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask(Task? task) async {
    if (task == null) return 0;

    if (GetPlatform.isWeb) {
      task.id ??= DateTime.now().millisecondsSinceEpoch;
      taskList.add(task);
      _saveWebTasks();
      return 1;
    } else {
      int result = await DBHelper.insert(task);
      getTasks();
      return result;
    }
  }

  // get all tasks from database
  Future<void> getTasks() async {
    if (GetPlatform.isWeb) {
      List? data = box.read('tasks');

      if (data != null) {
        taskList.assignAll(data.map((e) => Task.fromJson(e)).toList());
      } else {
        taskList.clear();
      }
      return;
    }

    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  Future<void> deleteTask(Task task) async {
    if (GetPlatform.isWeb) {
      taskList.remove(task);
      _saveWebTasks();
      return;
    }

    if (task.id != null) {
      await DBHelper.delete(task.id!);
      await getTasks();
    }
  }

  void markTaskCompleted(int id) async {
    if (GetPlatform.isWeb) {
      Task? task;
      try {
        task = taskList.firstWhere((task) => task.id == id);
      } catch (e) {
        task = null;
      }
      if (task != null) {
        task.isCompleted = 1;
        _saveWebTasks();
        taskList.refresh();
      }
    } else {
      await DBHelper.update(id);
      getTasks();
    }
  }

  Future<void> updateTask(Task task) async {
    if (GetPlatform.isWeb) {
      int index = taskList.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        taskList[index] = task;
        taskList.refresh();
        _saveWebTasks();
      }
    } else {
      await DBHelper.updateTask(task);
      getTasks();
    }
  }

  void _saveWebTasks() {
    box.write('tasks', taskList.map((e) => e.toJson()).toList());
  }
}
