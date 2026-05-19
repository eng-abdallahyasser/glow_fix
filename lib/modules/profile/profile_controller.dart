import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Vehicle {
  final String id;
  final String name;
  final String licensePlate;

  Vehicle({
    required this.id,
    required this.name,
    required this.licensePlate,
  });
}

class ProfileController extends GetxController {
  // --- Profile Summary & Initials ---
  final userName = 'Mahmoud Ali'.obs;
  final userEmail = 'Mohamed@example.com'.obs;
  final userPhone = '+20 100 000 0000'.obs;
  final memberTier = 'Gold Tier'.obs;
  final profileImageUrl = RxnString(); // Null means show initials

  // Text Controllers for input fields
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;

  // --- Phone Verification ---
  final isPhoneVerified = false.obs;

  // --- Vehicles List ---
  final vehicles = <Vehicle>[
    Vehicle(id: '1', name: 'Toyota Corolla', licensePlate: 'A 1234 B'),
    Vehicle(id: '2', name: 'Hyundai Elantra', licensePlate: 'License Plate...'),
  ].obs;

  // --- Loyalty & Rewards ---
  final totalPoints = 1250.obs;
  final tierProgress = 0.7.obs; // 70% progress as in Figma (left: 0%, right: 30%)
  
  final recentActivities = <Map<String, dynamic>>[
    {'title': 'Car Wash Service', 'points': '+150 pts'},
    {'title': 'Oil Change', 'points': '+100 pts'},
  ].obs;

  // --- Active Sessions ---
  final activeSessions = <Map<String, dynamic>>[
    {
      'id': 's1',
      'device': 'Mac',
      'browser': 'Safari',
      'location': 'Cairo',
      'isCurrent': true,
      'status': 'Current'
    },
    {
      'id': 's2',
      'device': 'iPhone',
      'browser': 'howh app',
      'location': '',
      'isCurrent': false,
      'status': '2 hr ago'
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controller text fields
    nameController = TextEditingController(text: userName.value);
    emailController = TextEditingController(text: userEmail.value);
    phoneController = TextEditingController(text: userPhone.value);
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();

    // Listen to changes in controllers if needed, or simply update state on Save
    nameController.addListener(() {
      userName.value = nameController.text;
    });
    emailController.addListener(() {
      userEmail.value = emailController.text;
    });
    phoneController.addListener(() {
      userPhone.value = phoneController.text;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }

  // --- Actions & Implementation TODOs ---

  /// Upload/Update the profile picture
  Future<void> uploadProfilePicture() async {
    // TODO: 1. Launch ImagePicker to select image from Gallery or Camera.
    // TODO: 2. Implement Image Cropper for circular sizing aspect ratio 1:1.
    // TODO: 3. Show a loading overlay during upload.
    // TODO: 4. Send image bytes/file to the backend API or direct cloud storage (e.g. Firebase Storage/S3).
    // TODO: 5. Retrieve the secure download URL and update `profileImageUrl.value`.
    // TODO: 6. Trigger backend user update API to store the new photo URL.
    Get.snackbar(
      'Profile Picture',
      'Uploading profile photo feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  /// Trigger Profile Image Edit/Delete options sheet
  void editProfileImageOption() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                uploadProfilePicture();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                uploadProfilePicture();
              },
            ),
            if (profileImageUrl.value != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Current Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  profileImageUrl.value = null;
                  Get.back();
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Save Personal Info to the backend
  Future<void> savePersonalInfo() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Full name, email, and phone number fields cannot be empty.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
      return;
    }

    try {
      // TODO: 1. Show global circular loader / progress hud.
      // TODO: 2. Call backend API endpoint PUT /api/v1/profile/info with name, email, phone.
      // TODO: 3. Verify response status.
      // TODO: 4. Sync new profile info with auth state/session storage.
      // TODO: 5. Dismiss progress hud.
      
      Get.snackbar(
        'Success',
        'Personal information updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF006E2F),
        colorText: Colors.white,
      );
    } catch (e) {
      // TODO: Handle exceptions or server error responses nicely
      Get.snackbar(
        'Error',
        'Failed to save info: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
    }
  }

  /// Start phone number OTP verification flow
  Future<void> verifyPhoneNumber() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar(
        'Verification Failed',
        'Please enter a valid phone number first.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
      return;
    }

    // TODO: 1. Trigger request POST /api/v1/auth/request-otp with phone.
    // TODO: 2. Launch code verification Dialog / Bottom Sheet.
    // TODO: 3. Submit OTP code POST /api/v1/auth/verify-otp.
    // TODO: 4. On success, set isPhoneVerified.value = true.
    
    Get.snackbar(
      'OTP Sent',
      'Verification code sent to $phone (MOCK)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF004AC6),
      colorText: Colors.white,
    );
    // Mocking successful verification for UI demonstration
    isPhoneVerified.value = true;
  }

  /// Show sheet or dialog to add a vehicle
  void showAddVehicleDialog() {
    final modelController = TextEditingController();
    final plateController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Vehicle',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF191B23),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                labelText: 'Vehicle Model (e.g. Toyota Corolla)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(
                labelText: 'License Plate (e.g. A 1234 B)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004AC6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                final model = modelController.text.trim();
                final plate = plateController.text.trim();
                if (model.isNotEmpty && plate.isNotEmpty) {
                  addNewVehicle(model, plate);
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Please fill in both fields.');
                }
              },
              child: const Text('Add Vehicle'),
            ),
          ],
        ),
      ),
    );
  }

  /// Save new vehicle to list/backend
  Future<void> addNewVehicle(String model, String licensePlate) async {
    // TODO: 1. Send POST /api/v1/vehicles with body { name, licensePlate }.
    // TODO: 2. Add response vehicle object to the local list `vehicles`.
    
    final newId = (vehicles.length + 1).toString();
    vehicles.add(Vehicle(id: newId, name: model, licensePlate: licensePlate));

    Get.snackbar(
      'Vehicle Added',
      '$model has been added successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006E2F),
      colorText: Colors.white,
    );
  }

  /// Show sheet or dialog to edit vehicle details
  void showEditVehicleDialog(Vehicle vehicle) {
    final modelController = TextEditingController(text: vehicle.name);
    final plateController = TextEditingController(text: vehicle.licensePlate);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Vehicle Details',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF191B23),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                labelText: 'Vehicle Model',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(
                labelText: 'License Plate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004AC6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                final model = modelController.text.trim();
                final plate = plateController.text.trim();
                if (model.isNotEmpty && plate.isNotEmpty) {
                  editVehicle(vehicle.id, model, plate);
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Fields cannot be empty.');
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  /// Update vehicle details on backend
  Future<void> editVehicle(String id, String model, String licensePlate) async {
    // TODO: 1. Send PUT /api/v1/vehicles/$id with body { name, licensePlate }.
    // TODO: 2. Update local vehicles list on success.
    
    final index = vehicles.indexWhere((element) => element.id == id);
    if (index != -1) {
      vehicles[index] = Vehicle(id: id, name: model, licensePlate: licensePlate);
      vehicles.refresh();
      
      Get.snackbar(
        'Vehicle Updated',
        'Vehicle details updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF006E2F),
        colorText: Colors.white,
      );
    }
  }

  /// Delete a vehicle
  Future<void> deleteVehicle(String id) async {
    // TODO: 1. Send DELETE /api/v1/vehicles/$id.
    // TODO: 2. Remove vehicle from local list on success.
    
    vehicles.removeWhere((element) => element.id == id);

    Get.snackbar(
      'Vehicle Removed',
      'Vehicle has been deleted from your profile.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBA1A1A),
      colorText: Colors.white,
    );
  }

  /// Redeem user loyalty rewards points
  Future<void> redeemRewards() async {
    // TODO: 1. Open rewards boutique / list of available redeemable coupons.
    // TODO: 2. Select reward.
    // TODO: 3. Call backend endpoint POST /api/v1/rewards/redeem with body { reward_id, points }.
    // TODO: 4. Deduct local totalPoints on success.
    
    Get.snackbar(
      'Redeem Points',
      'Redeeming options and gift vouchers are loading...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF006E2F),
      colorText: Colors.white,
    );
  }

  /// Change security password
  Future<void> changePassword() async {
    final currentPass = currentPasswordController.text;
    final newPass = newPasswordController.text;

    if (currentPass.isEmpty || newPass.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Both Current and New password fields must be filled.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar(
        'Weak Password',
        'New password must be at least 6 characters long.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
      return;
    }

    try {
      // TODO: 1. Send POST /api/v1/auth/change-password with body { currentPass, newPass }.
      // TODO: 2. Handle HTTP responses.
      // TODO: 3. Clear text fields.
      
      currentPasswordController.clear();
      newPasswordController.clear();
      
      Get.snackbar(
        'Password Updated',
        'Your account security password has been changed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF006E2F),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFBA1A1A),
        colorText: Colors.white,
      );
    }
  }

  /// Revoke active session
  Future<void> revokeSession(String sessionId) async {
    // TODO: 1. Send POST /api/v1/auth/sessions/revoke with body { sessionId }.
    // TODO: 2. Remove session from list.
    
    activeSessions.removeWhere((session) => session['id'] == sessionId);
    
    Get.snackbar(
      'Session Revoked',
      'Device session logged out successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFBA1A1A),
      colorText: Colors.white,
    );
  }

  /// Customer Help & Support
  void openHelpSupport() {
    // TODO: 1. Integrate chat provider SDK (e.g. Intercom, Zendesk, Freshdesk).
    // TODO: 2. Launch customer support web view or in-app live chat screen.
    
    Get.snackbar(
      'Support Chat',
      'Opening Support Hotline & Live Chat...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF004AC6),
      colorText: Colors.white,
    );
  }

  /// Delete Account permanently
  Future<void> deleteAccount() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account?', style: TextStyle(color: Color(0xFFBA1A1A))),
        content: const Text(
          'This action is permanent and cannot be undone. All your personal info, vehicles, and loyalty points will be permanently deleted.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA1A1A)),
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Get.back();
              // TODO: 1. Call DELETE /api/v1/auth/account.
              // TODO: 2. Revoke local secure auth tokens.
              // TODO: 3. Clear databases/caches.
              // TODO: 4. Navigate out to login screen.
              
              Get.snackbar(
                'Account Purged',
                'Your account has been deleted.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFFBA1A1A),
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Sign out/Logout of session
  Future<void> logout() async {
    // TODO: 1. Send POST /api/v1/auth/logout to invalidate backend refresh tokens.
    // TODO: 2. Clean local key-value store (e.g., GetStorage or flutter_secure_storage).
    // TODO: 3. Clear memory caches.
    // TODO: 4. Navigate back to login view.
    
    Get.offAllNamed('/login');
    
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF434655),
      colorText: Colors.white,
    );
  }
}
