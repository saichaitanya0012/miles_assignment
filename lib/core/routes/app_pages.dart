import 'package:get/get.dart';
import 'package:miles_education_task/presentation/auth/views/login_view.dart';
import 'package:miles_education_task/presentation/auth/views/signup_view.dart';
import 'package:miles_education_task/presentation/tasks/views/task_list_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(name: Routes.login, page: () => const LoginView()),
    GetPage(name: Routes.signup, page: () => const SignupView()),
    GetPage(name: Routes.taskList, page: () => const TaskListView()),
    // GetPage(name: Routes.taskCreate, page: () => const TaskCreateView()),
  ];
}
