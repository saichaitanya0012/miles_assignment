import 'package:get/get.dart';
import 'package:miles_education_task/presentation/auth/controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize controllers that should persist throughout the app lifecycle
    Get.put(AuthController(), permanent: true);
  }
}
