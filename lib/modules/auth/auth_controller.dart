import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  // Login form state
  final loginEmail = ''.obs;
  final loginPassword = ''.obs;
  final isLoginPasswordVisible = false.obs;

  // Register form state
  final registerName = ''.obs;
  final registerEmail = ''.obs;
  final registerPhone = ''.obs;
  final registerPassword = ''.obs;
  final isRegisterPasswordVisible = false.obs;
  final agreeToTerms = false.obs;

  // Toggles password visibility
  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
  }

  // Toggles terms acceptance checkbox
  void toggleTermsAcceptance() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  // Navigation helpers
  void navigateToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void navigateToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  // Action methods (Mocked)
  void login() {
    if (loginEmail.value.isEmpty || loginPassword.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter all credentials.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Navigate to dashboard main shell upon success
    Get.offAllNamed(Routes.MAIN);
  }

  void register() {
    if (registerName.value.isEmpty ||
        registerEmail.value.isEmpty ||
        registerPhone.value.isEmpty ||
        registerPassword.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all registration fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Error',
        'You must agree to the Terms & Conditions.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Navigate to dashboard main shell upon success
    Get.offAllNamed(Routes.MAIN);
  }
}
