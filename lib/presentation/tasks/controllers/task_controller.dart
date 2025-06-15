import 'package:get/get.dart';
import 'package:miles_education_task/data/models/task_model.dart';
import 'package:miles_education_task/data/repositories/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _repository = TaskRepository();
  final tasks = <TaskModel>[].obs;
  final isLoading = false.obs;
  late final Stream<List<TaskModel>> _tasksStream;

  @override
  void onInit() {
    super.onInit();
    _tasksStream = _repository.getTasks();
    _loadTasks();
  }

  void _loadTasks() {
    ever(tasks, (_) {
      // This will trigger whenever tasks are updated
      update();
    });

    _tasksStream.listen(
      (taskList) {
        tasks.assignAll(taskList);
      },
      onError: (error) {
        Get.snackbar(
          'Error',
          'Failed to load tasks',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> refreshTasks() async {
    try {
      isLoading.value = true;
      final taskList = await _repository.getTasksOnce();
      tasks.assignAll(taskList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh tasks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    DateTime? dueDate,
  }) async {
    try {
      isLoading.value = true;
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final task = TaskModel(
        id: tempId,
        title: title,
        description: description,
        createdAt: DateTime.now(),
        dueDate: dueDate,
        userId: _repository.userId,
      );

      final docRef = await _repository.addTask(task);
      // Update the task with the actual Firestore ID
      final updatedTask = task.copyWith(id: docRef.id);
      final index = tasks.indexWhere((t) => t.id == tempId);
      if (index != -1) {
        tasks[index] = updatedTask;
      } else {
        tasks.insert(0, updatedTask);
      }
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add task',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      isLoading.value = true;
      await _repository.updateTask(task);
      // Update the task in the local list immediately
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
      }
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      isLoading.value = true;
      await _repository.deleteTask(taskId);
      // Remove the task from the local list immediately
      tasks.removeWhere((task) => task.id == taskId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete task',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    try {
      await _repository.toggleTaskCompletion(task);
      // Update the task completion status in the local list immediately
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    tasks.close();
    super.onClose();
  }
}
