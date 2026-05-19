import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/app_colors.dart';
import 'auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Main Auth Card Container
                _buildAuthCard(context),
                
                const SizedBox(height: 24),
                
                // 2. Support / Footer Links
                _buildSupportFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 448),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            // Top Banner Header Section with Hero image style
            _buildHeroHeader(),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  _buildWelcomeText(),
                  
                  const SizedBox(height: 24),
                  
                  // Login inputs
                  _buildLoginForm(),
                  
                  const SizedBox(height: 24),
                  
                  // Divider
                  _buildDividerSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Social buttons
                  _buildSocialGrid(),
                  
                  const SizedBox(height: 24),
                  
                  // Sign Up Link Toggle
                  _buildSignUpToggle(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      height: 192,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background abstract shape overlay for 0.4 opacity mockup look
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                ),
                itemCount: 24,
              ),
            ),
          ),
          
          // Branding Logo inside Banner
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEFFF).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: Color(0xFFEEEFFF),
                  size: 34,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'GlowFix',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEEEFFF),
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191B23),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to manage your appointments and wellness services.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF434655),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Input
        _buildInputField(
          label: 'EMAIL ADDRESS',
          placeholder: 'name@example.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => controller.loginEmail.value = val,
        ),
        
        const SizedBox(height: 18),
        
        // Password Input with Forgot Password option
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF434655),
                    letterSpacing: 0.6,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Obx(() => _buildInputContainer(
                  icon: Icons.lock_outline_rounded,
                  child: TextField(
                    obscureText: !controller.isLoginPasswordVisible.value,
                    onChanged: (val) => controller.loginPassword.value = val,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF191B23),
                    ),
                    decoration: const InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  suffixWidget: IconButton(
                    onPressed: controller.toggleLoginPasswordVisibility,
                    icon: Icon(
                      controller.isLoginPasswordVisible.value
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: const Color(0xFF737686),
                      size: 20,
                    ),
                  ),
                )),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Login Button Capsule
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            onPressed: controller.login,
            child: const Text(
              'Login',
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
    TextInputType? keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF434655),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        _buildInputContainer(
          icon: icon,
          child: TextField(
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
      ],
    );
  }

  Widget _buildInputContainer({
    required IconData icon,
    required Widget child,
    Widget? suffixWidget,
  }) {
    return Container(
      height: 57,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC3C6D7)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, color: const Color(0xFF737686), size: 20),
          const SizedBox(width: 12),
          Expanded(child: child),
          if (suffixWidget != null) suffixWidget,
        ],
      ),
    );
  }

  Widget _buildDividerSection() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFC3C6D7))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF737686),
              letterSpacing: 0.6,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFC3C6D7))),
      ],
    );
  }

  Widget _buildSocialGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
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

  Widget _buildSignUpToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF434655),
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: controller.navigateToRegister,
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterLink('TERMS'),
            _buildFooterDivider(),
            _buildFooterLink('PRIVACY'),
            _buildFooterDivider(),
            _buildFooterLink('SUPPORT'),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          '© 2026 GLOWFIX SERVICES. ALL RIGHTS RESERVED.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC3C6D7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF737686),
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '|',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFF737686),
        ),
      ),
    );
  }
}
