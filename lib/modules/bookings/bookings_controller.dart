import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingItem {
  final String id;
  final String providerName;
  final String serviceName;
  final String dateTime;
  final double price;
  final RxString status; // 'Confirmed', 'Ready', 'Pending'
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  BookingItem({
    required this.id,
    required this.providerName,
    required this.serviceName,
    required this.dateTime,
    required this.price,
    required String status,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  }) : this.status = status.obs;
}

class BookingsController extends GetxController {
  // Active Filter: 'Upcoming', 'Completed', 'Pending'
  final activeFilter = 'Upcoming'.obs;

  // Booking list based on Figma mockup data
  final bookings = <BookingItem>[
    BookingItem(
      id: '1',
      providerName: 'Voltline Auto Electric',
      serviceName: 'Standard Diagnostics',
      dateTime: 'Mon, May 24 • 10:30 AM',
      price: 85.00,
      status: 'Confirmed',
      icon: Icons.flash_on_rounded,
      iconBgColor: const Color(0xFFDBE1FF),
      iconColor: const Color(0xFF004AC6),
    ),
    BookingItem(
      id: '2',
      providerName: 'Shine & Co. Detailing',
      serviceName: 'Full Exterior Hand Wash',
      dateTime: 'Mon, May 24 • 10:30 AM',
      price: 120.00,
      status: 'Ready',
      icon: Icons.local_car_wash_rounded,
      iconBgColor: const Color(0xFF6BFF8F),
      iconColor: const Color(0xFF007432),
    ),
    BookingItem(
      id: '3',
      providerName: 'Elite Engine Works',
      serviceName: 'Brake Pad Replacement',
      dateTime: 'Wed, May 26 • 02:00 PM',
      price: 150.00,
      status: 'Pending',
      icon: Icons.build_rounded,
      iconBgColor: const Color(0xFFE7E7F3),
      iconColor: const Color(0xFF737686),
    ),
  ].obs;

  // Rating bottom sheet reactive variables
  final ratingService = 5.obs;
  final ratingPrice = 5.obs;
  final ratingSpeed = 5.obs;
  final ratingOverall = 5.obs;
  final feedbackController = TextEditingController();

  // Reset ratings for bottom sheet modal
  void resetRatings() {
    ratingService.value = 5;
    ratingPrice.value = 5;
    ratingSpeed.value = 5;
    ratingOverall.value = 5;
    feedbackController.clear();
  }

  // Filtered list of bookings based on active filter
  List<BookingItem> get filteredBookings {
    if (activeFilter.value == 'Upcoming') {
      return bookings.where((b) => b.status.value == 'Confirmed').toList();
    } else if (activeFilter.value == 'Completed') {
      return bookings.where((b) => b.status.value == 'Ready').toList();
    } else if (activeFilter.value == 'Pending') {
      return bookings.where((b) => b.status.value == 'Pending').toList();
    }
    return bookings;
  }

  // Action methods
  void cancelBooking(BookingItem booking) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Cancel Booking',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel your booking with ${booking.providerName}?',
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            child: const Text('No', style: TextStyle(color: Color(0xFF434655))),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () {
              bookings.remove(booking);
              Get.back();
              Get.snackbar(
                'Booking Cancelled',
                'Your service reservation has been successfully cancelled.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFFFFDAD9),
                colorText: const Color(0xFF410002),
              );
            },
          ),
        ],
      ),
    );
  }

  void rescheduleBooking(BookingItem booking) {
    Get.snackbar(
      'Reschedule Service',
      'Contacting ${booking.providerName} to pick a new time slot...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFDBE1FF),
      colorText: const Color(0xFF004AC6),
    );
  }

  void submitReview(String providerName) {
    final comment = feedbackController.text.trim();
    Get.back(); // close bottom sheet
    Get.snackbar(
      'Review Submitted',
      'Thank you for rating your service at $providerName!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFE8F5E9),
      colorText: const Color(0xFF2E7D32),
      duration: const Duration(seconds: 3),
    );
    resetRatings();
  }
}
