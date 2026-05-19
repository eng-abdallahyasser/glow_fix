import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_fix/core/widgets/top_app_bar.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // --- Figma Color System ---
  static const Color figmaBg = Color(0xFFFAF8FF);
  static const Color figmaCardBg = Color(0xFFFFFFFF);
  static const Color figmaBlue = Color(0xFF004AC6);
  static const Color figmaActivePill = Color(0xFF2563EB);
  static const Color figmaTextDark = Color(0xFF191B23);
  static const Color figmaTextMuted = Color(0xFF434655);
  static const Color figmaBorder = Color(0xFFC3C6D7);
  static const Color figmaGreen = Color(0xFF006E2F);
  static const Color figmaRed = Color(0xFFBA1A1A);
  static const Color figmaIconGrey = Color(0xFF737686);
  static const Color figmaProgressBg = Color(0xFFE1E2ED);
  static const Color figmaLightBlue = Color(0xFFEDEDF9);
  static const Color figmaShadowColor = Color(0x0D000000); // rgba(0, 0, 0, 0.05)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: figmaBg,
      body: SafeArea(
        child: Column(
          children: [
            const MyTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileSummaryCard(),
                    const SizedBox(height: 24),
                    _buildPersonalInfoSection(),
                    const SizedBox(height: 24),
                    _buildMyVehiclesSection(),
                    const SizedBox(height: 24),
                    _buildLoyaltyRewardsSection(),
                    const SizedBox(height: 24),
                    _buildAccountSecuritySection(),
                    const SizedBox(height: 24),
                    _buildFooterActionsSection(),
                    const SizedBox(height: 80), // Extra space to scroll above bottom nav bar cleanly
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Section - Profile Summary ---
  Widget _buildProfileSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: figmaCardBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: figmaShadowColor,
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar Stack
          GestureDetector(
            onTap: controller.editProfileImageOption,
            child: Stack(
              children: [
                // Profile Image / Initials Background
                Obx(() {
                  final imgUrl = controller.profileImageUrl.value;
                  return Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: figmaActivePill,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: imgUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: Image.network(
                              imgUrl,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildInitials(),
                            ),
                          )
                        : _buildInitials(),
                  );
                }),
                // Edit Icon Camera Badge at Bottom Right
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: figmaBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Heading 2: Name
          Obx(() => Text(
                controller.userName.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  height: 1.4,
                  color: figmaTextDark,
                ),
              )),
          const SizedBox(height: 4),
          // Subtext: Member Tier / Email
          Obx(() => Text(
                '${controller.memberTier.value} • ${controller.userEmail.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.43,
                  color: figmaTextMuted,
                ),
              )),
          const SizedBox(height: 16),
          // Edit Profile Image Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              side: const BorderSide(color: figmaBorder, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            onPressed: controller.editProfileImageOption,
            child: const Text(
              'Change Photo',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                color: figmaTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials() {
    // Generate initials dynamically from user name
    final name = controller.userName.value.trim();
    String initials = 'MA';
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[1][0]).toUpperCase();
      } else {
        initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
      }
    }
    return Text(
      initials,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5,
        color: Colors.white,
      ),
    );
  }

  // --- Section - Personal Info ---
  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading 3
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'PERSONAL INFO',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.6,
              color: figmaTextMuted,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: figmaCardBg,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: figmaShadowColor,
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name field
              _buildInputFieldLabel('FULL NAME'),
              const SizedBox(height: 4.5),
              _buildTextInputField(
                controller: controller.nameController,
                hintText: 'Enter your full name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              // Email Address field
              _buildInputFieldLabel('EMAIL ADDRESS'),
              const SizedBox(height: 4.5),
              _buildTextInputField(
                controller: controller.emailController,
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Phone Number field
              _buildInputFieldLabel('PHONE NUMBER'),
              const SizedBox(height: 4.5),
              _buildPhoneInputField(),
              const SizedBox(height: 24),

              // Save Changes Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: figmaBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                onPressed: controller.savePersonalInfo,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 10,
        height: 1.5,
        color: figmaTextMuted,
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: figmaCardBg,
        border: Border.all(color: figmaBorder, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: figmaTextDark,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: figmaCardBg,
        border: Border.all(color: figmaBorder, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: figmaTextDark,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                contentPadding: EdgeInsets.only(left: 16, right: 8, top: 13, bottom: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // Verify Badge/Button on right side
          Obx(() {
            final isVerified = controller.isPhoneVerified.value;
            return GestureDetector(
              onTap: isVerified ? null : controller.verifyPhoneNumber,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Text(
                  isVerified ? 'Verified' : 'Verify',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: isVerified ? figmaGreen : figmaBlue,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- Section - My Vehicles ---
  Widget _buildMyVehiclesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header (Title & Add New button)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'MY VEHICLES',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: 1.33,
                  letterSpacing: 0.6,
                  color: figmaTextMuted,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.showAddVehicleDialog,
              child: const Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 14,
                    color: figmaBlue,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Add New',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: figmaBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Vehicles List view
        Obx(() {
          if (controller.vehicles.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: figmaCardBg,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Center(
                child: Text(
                  'No vehicles registered. Add one to start!',
                  style: TextStyle(fontFamily: 'Inter', color: figmaTextMuted),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.vehicles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final vehicle = controller.vehicles[index];
              return _buildVehicleCard(vehicle);
            },
          );
        }),
      ],
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: figmaCardBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: figmaShadowColor,
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon with Background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: figmaLightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: figmaBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Vehicle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.5,
                    color: figmaTextDark,
                  ),
                ),
                Text(
                  vehicle.licensePlate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.43,
                    color: figmaTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Edit & Delete Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_rounded,
                  color: figmaIconGrey,
                  size: 20,
                ),
                onPressed: () => controller.showEditVehicleDialog(vehicle),
              ),
              const SizedBox(width: 12),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: figmaIconGrey,
                  size: 20,
                ),
                onPressed: () => controller.deleteVehicle(vehicle.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Section - Loyalty & Rewards ---
  Widget _buildLoyaltyRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading 3
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'LOYALTY & REWARDS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.6,
              color: figmaTextMuted,
            ),
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: figmaCardBg,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: figmaShadowColor,
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Points & Redeeming Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL POINTS',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      height: 1.5,
                      color: figmaTextMuted,
                    ),
                  ),
                  Obx(() => Text(
                        controller.totalPoints.value.toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            ),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          height: 1.21,
                          letterSpacing: -0.28,
                          color: figmaBlue,
                        ),
                      )),
                  Obx(() => Text(
                        controller.memberTier.value,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.43,
                          color: figmaGreen,
                        ),
                      )),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: figmaGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16.67, vertical: 8),
                  minimumSize: const Size(122, 49),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                onPressed: controller.redeemRewards,
                child: const Text(
                  'Redeem Rewards',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Loyalty Tier Progress Bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: figmaProgressBg,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              Obx(() => FractionallySizedBox(
                    widthFactor: controller.tierProgress.value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: figmaBlue,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),

          // Recent Activity Area
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: figmaBorder, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'RECENT ACTIVITY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    height: 1.5,
                    color: figmaTextMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recentActivities.length,
                      separatorBuilder: (context, idx) => const SizedBox(height: 4),
                      itemBuilder: (context, idx) {
                        final act = controller.recentActivities[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                act['title'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1.5,
                                  color: figmaTextDark,
                                ),
                              ),
                              Text(
                                act['points'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 1.5,
                                  color: figmaGreen,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);
}

  // --- Section - Account Security ---
  Widget _buildAccountSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading 3
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'ACCOUNT SECURITY',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.33,
              letterSpacing: 0.6,
              color: figmaTextMuted,
            ),
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: figmaCardBg,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: figmaShadowColor,
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Update Password Header
              const Text(
                'Update password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
                  color: figmaTextDark,
                ),
              ),
              const SizedBox(height: 8),

              // Inputs for Password Change
              _buildTextInputField(
                controller: controller.currentPasswordController,
                hintText: 'Current password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              _buildTextInputField(
                controller: controller.newPasswordController,
                hintText: 'New password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(height: 8),

              // Change Password Button
              GestureDetector(
                onTap: controller.changePassword,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 32,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: figmaBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Active Sessions Sub-Section
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: figmaBorder, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'ACTIVE SESSIONS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        height: 1.5,
                        color: figmaTextMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.activeSessions.length,
                          separatorBuilder: (context, idx) => const SizedBox(height: 12),
                          itemBuilder: (context, idx) {
                            final session = controller.activeSessions[idx];
                            final isCurrent = session['isCurrent'] == true;
                            final isDesktop = session['device'] == 'Mac';

                            return Row(
                              children: [
                                // Device Icon
                                Container(
                                  width: 24,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    isDesktop
                                        ? Icons.laptop_chromebook_rounded
                                        : Icons.phone_iphone_rounded,
                                    color: figmaIconGrey,
                                    size: isDesktop ? 22 : 20,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Session details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${session['device']} • ${session['browser']}${session['location'].isNotEmpty ? ' • ${session['location']}' : ''}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          height: 1.5,
                                          color: figmaTextDark,
                                        ),
                                      ),
                                      Text(
                                        session['status'],
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: isCurrent
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          fontSize: 14,
                                          height: 1.43,
                                          color: isCurrent ? figmaGreen : figmaTextMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Invalidate session icon button (excluding current session)
                                if (!isCurrent)
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.highlight_off_rounded,
                                      color: figmaRed,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        controller.revokeSession(session['id']),
                                  ),
                              ],
                            );
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Section - Footer Actions ---
  Widget _buildFooterActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Button 1: Customer Support
        _buildFooterBorderedButton(
          icon: Icons.help_outline_rounded,
          text: 'Customer Support',
          textColor: figmaTextDark,
          iconColor: figmaTextDark,
          onPressed: controller.openHelpSupport,
        ),
        const SizedBox(height: 16),

        // Button 2: Delete Account
        _buildFooterBorderedButton(
          icon: Icons.delete_forever_rounded,
          text: 'Delete Account',
          textColor: figmaRed,
          iconColor: figmaRed,
          onPressed: controller.deleteAccount,
        ),
        const SizedBox(height: 16),

        // Button 3: Log Out
        _buildFooterBorderedButton(
          icon: Icons.logout_rounded,
          text: 'Log Out',
          textColor: figmaTextMuted,
          iconColor: figmaTextMuted,
          onPressed: controller.logout,
        ),
        const SizedBox(height: 16),

        // Muted Copyright Footer Text
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Version 1.0.0 (build 123) • © glow_fix',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 11,
              height: 1.45,
              color: figmaIconGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterBorderedButton({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: figmaBorder, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        minimumSize: const Size(double.infinity, 56),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.5,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
