import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/app_colors.dart';
import 'auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6), // At 10% 20% from top left
            radius: 1.5,
            colors: [
              Color(0x0D2563EB), // rgba(37, 99, 235, 0.05)
              Color(0x002563EB), // rgba(37, 99, 235, 0)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: Container(
          color: const Color(
            0xFFFAF8FF,
          ).withOpacity(0.3), // overlay linear-gradient(0deg, #FAF8FF, #FAF8FF)
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // 1. Hero / Brand Section
                  _buildBrandSection(),

                  const SizedBox(height: 16),

                  // 2. Form Section
                  _buildRegistrationForm(context),

                  const SizedBox(height: 24),

                  // 3. Social Login Section
                  _buildSocialSection(),

                  const SizedBox(height: 32),

                  // 4. Already have an account? Login
                  _buildLoginLink(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      children: [
        // Blue logo box
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.spa_rounded, // Premium Wellness Icon
              color: Colors.white,
              size: 38,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Heading
        const Text(
          'Create Account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF191B23),
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 12),

        // Description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Find and book the best wellness treatments near you',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF434655),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        _buildInputField(
          label: 'FULL NAME',
          placeholder: 'John Doe',
          icon: Icons.person_outline_rounded,
          onChanged: (val) => controller.registerName.value = val,
        ),

        const SizedBox(height: 18),

        // Email Field
        _buildInputField(
          label: 'EMAIL ADDRESS',
          placeholder: 'john@example.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => controller.registerEmail.value = val,
        ),

        const SizedBox(height: 18),

        // Phone Field
        _buildInputField(
          label: 'PHONE NUMBER',
          placeholder: '+1 (555) 000-0000',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          onChanged: (val) => controller.registerPhone.value = val,
        ),

        const SizedBox(height: 18),

        // Password Field
        Obx(
          () => _buildInputField(
            label: 'PASSWORD',
            placeholder: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: !controller.isRegisterPasswordVisible.value,
            onChanged: (val) => controller.registerPassword.value = val,
            suffixWidget: IconButton(
              onPressed: controller.toggleRegisterPasswordVisibility,
              icon: Icon(
                controller.isRegisterPasswordVisible.value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: const Color(0xFF737686),
                size: 20,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Terms & Conditions Checkbox Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => GestureDetector(
                onTap: controller.toggleTermsAcceptance,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.agreeToTerms.value
                        ? AppColors.primary
                        : Colors.white,
                    border: Border.all(
                      color: controller.agreeToTerms.value
                          ? AppColors.primary
                          : const Color(0xFFC3C6D7),
                    ),
                    borderRadius: BorderRadius.circular(6), // custom rounded
                  ),
                  child: controller.agreeToTerms.value
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'I agree to the Terms & Conditions and Privacy Policy.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF434655),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Sign Up Button Capsule
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004AC6),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            onPressed: controller.register,
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixWidget,
    TextInputType? keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 6),

          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF434655),
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(
          height: 57,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC3C6D7)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: const Color(0xFF737686), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Color(0xFF191B23),
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (suffixWidget != null) suffixWidget,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        // Horizontal Dividers
        Row(
          children: [
            const Expanded(child: Divider(color: Color(0xFFC3C6D7))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC3C6D7),
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const Expanded(child: Divider(color: Color(0xFFC3C6D7))),
          ],
        ),

        const SizedBox(height: 20),

        // Google & Apple Login Button
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                iconUrl:
                    'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                label: 'Google',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSocialButton(
                iconUrl: 'https://cdn-icons-png.flaticon.com/512/0/747.png',
                label: 'Apple',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({required String iconUrl, required String label}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFC3C6D7)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(9999),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                iconUrl,
                width: 18,
                height: 18,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.g_mobiledata_rounded, size: 22),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191B23),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF434655),
          ),
        ),
        GestureDetector(
          onTap: controller.navigateToLogin,
          child: const Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004AC6),
            ),
          ),
        ),
      ],
    );
  }
}
