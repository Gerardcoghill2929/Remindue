import 'package:get_storage/get_storage.dart';
import 'package:remindue/models/task.dart';

class WebStorage {
  final box = GetStorage();

  List<Task> getTasks() {
    List? data = box.read('tasks');
    if (data == null) return [];
    return data.map((e) => Task.fromJson(e)).toList();
  }

  void saveTasks(List<Task> tasks) {
    box.write('tasks', tasks.map((e) => e.toJson()).toList());
  }
}
