import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_fix/core/widgets/top_app_bar.dart';
import '../../core/values/app_colors.dart';
import 'bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({super.key});

  // Color specs from Figma auto layout
  static const Color figmaBg = Color(0xFFFAF8FF);
  static const Color figmaCardBg = Color(0xFFFFFFFF);
  static const Color figmaBlue = Color(0xFF004AC6);
  static const Color figmaActivePill = Color(0xFF2563EB);
  static const Color figmaTextDark = Color(0xFF191B23);
  static const Color figmaTextMuted = Color(0xFF434655);
  static const Color figmaTextSubtle = Color(0xFF737686);
  static const Color figmaBorder = Color(0xFFC3C6D7);
  static const Color figmaPillBg = Color(0xFFE7E7F3);
  static const Color figmaShadowColor = Color(0x0D000000); // rgba(0,0,0,0.05)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: figmaBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Standard Brand TopAppBar Shell
            const MyTopAppBar(),

            // Main Content Canvas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // Section - Filter Bar
                    _buildFilterBar(),
                    const SizedBox(height: 24),

                    // Bookings List Area
                    Expanded(
                      child: Obx(() {
                        final list = controller.filteredBookings;
                        if (list.isEmpty) {
                          return _buildEmptyState();
                        }
                        return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: list.length + 1, // Add promo banner in the middle
                          separatorBuilder: (context, index) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            // Render promo banner at index 1 to elevate aesthetics
                            if (index == 1) {
                              return _buildPromoCard();
                            }
                            final bookingIndex = index > 1 ? index - 1 : index;
                            if (bookingIndex >= list.length) {
                              return const SizedBox.shrink();
                            }
                            final booking = list[bookingIndex];
                            return _buildBookingCard(context, booking);
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Horizontal Filter bar ---
  Widget _buildFilterBar() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildFilterPill('Upcoming'),
          const SizedBox(width: 8),
          _buildFilterPill('Completed'),
          const SizedBox(width: 8),
          _buildFilterPill('Pending'),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String filterName) {
    return Obx(() {
      final isSelected = controller.activeFilter.value == filterName;
      return GestureDetector(
        onTap: () => controller.activeFilter.value = filterName,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? figmaActivePill : figmaPillBg,
            borderRadius: BorderRadius.circular(9999),
          ),
          alignment: Alignment.center,
          child: Text(
            filterName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.43,
              color: isSelected ? const Color(0xFFEEEFFF) : figmaTextMuted,
            ),
          ),
        ),
      );
    });
  }

  // --- Empty State UI ---
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: figmaPillBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            size: 32,
            color: figmaTextSubtle,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No Service Bookings',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: figmaTextDark,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Text(
              'You have no ${controller.activeFilter.value.toLowerCase()} bookings.',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: figmaTextMuted,
              ),
            )),
      ],
    );
  }

  // --- Booking Card Layout ---
  Widget _buildBookingCard(BuildContext context, BookingItem booking) {
    return Container(
      decoration: BoxDecoration(
        color: figmaCardBg,
        border: Border.all(color: figmaBorder.withOpacity(0.3), width: 1),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Header (Avatar, Provider info, status badge)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fully Rounded Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: booking.iconBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  booking.icon,
                  color: booking.iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Provider / Service Detail Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.providerName,
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
                      booking.serviceName,
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
              // Status Badge Overlay
              _buildStatusBadge(booking.status.value),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: Service Details (Date & Price)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date detail
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: figmaTextMuted),
                  const SizedBox(width: 8),
                  Text(
                    booking.dateTime,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: figmaTextMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Price detail
              Row(
                children: [
                  const Icon(Icons.sell_rounded, size: 14, color: figmaTextSubtle),
                  const SizedBox(width: 8),
                  Text(
                    '\$${booking.price.toStringAsFixed(2)} • Visa **** 4242',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: figmaTextSubtle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 3: Action Buttons (Cancel / Reschedule / Review)
          _buildActionButtons(context, booking),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    String label = status.toUpperCase();

    if (status == 'Confirmed') {
      bg = const Color(0x1A2563EB); // rgba(37, 99, 235, 0.1)
      text = const Color(0xFF2563EB);
    } else if (status == 'Ready') {
      bg = const Color(0x1ABC4800); // rgba(188, 72, 0, 0.1)
      text = const Color(0xFF943700);
      label = 'COMPLETED';
    } else {
      bg = const Color(0xFFE1E2ED);
      text = const Color(0xFF434655);
      label = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          height: 1.33,
          letterSpacing: 0.6,
          color: text,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, BookingItem booking) {
    if (booking.status.value == 'Ready') {
      // Completed Action Bar (Leave Review & Book Again)
      return Row(
        children: [
          // Book Again Button (Secondary)
          Expanded(
            child: SizedBox(
              height: 46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: figmaBorder, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => controller.rescheduleBooking(booking),
                child: const Text(
                  'Book Again',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: figmaTextDark,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Leave Review (Primary)
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: figmaBlue,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => _openRatingBottomSheet(context, booking),
                child: const Text(
                  'Review',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Confirmed / Pending Action Bar (Cancel & Reschedule)
      return Row(
        children: [
          // Cancel Button (Secondary Outline)
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: figmaBorder, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => controller.cancelBooking(booking),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: figmaTextDark,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Reschedule Button (Primary)
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: figmaActivePill,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => controller.rescheduleBooking(booking),
                child: const Text(
                  'Reschedule',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  // --- Hero Promo Card (GlowFix Pro Upgrade) ---
  Widget _buildPromoCard() {
    return Container(
      height: 192,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: figmaShadowColor,
            blurRadius: 15,
            spreadRadius: -3,
            offset: Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xCC000000), // rgba(0,0,0,0.8)
            Color(0x33000000), // rgba(0,0,0,0.2)
            Colors.transparent,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Abstract geometric layout with falling lines (Tech Bayesian Bayes Vibe)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      figmaBlue.withOpacity(0.95),
                      const Color(0xFF1E3A8A).withOpacity(0.85),
                      const Color(0xFF0F172A).withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Technical design rings
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 12),
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.04), width: 24),
                ),
              ),
            ),
            // Text Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Upgrade to GlowFix Pro',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Get priority bookings and 15% off on all luxury details.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.43,
                      color: Color(0xCCFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Rating Bottom Sheet Modal ---
  void _openRatingBottomSheet(BuildContext context, BookingItem booking) {
    controller.resetRatings();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color(0x66191B23), // rgba(25, 27, 35, 0.4)
      Container(
        height: 632,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000), // rgba(0,0,0,0.1)
              blurRadius: 30,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag Handle auto layout
            Container(
              height: 28,
              alignment: Alignment.center,
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: figmaBorder,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Block
                    const Text(
                      'How was your visit?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        height: 1.25,
                        color: figmaTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rate your service at ${booking.providerName}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        height: 1.5,
                        color: figmaTextMuted,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form - Dynamic Star Ratings
                    Column(
                      children: [
                        _buildInteractiveRatingRow('Service', controller.ratingService),
                        const SizedBox(height: 16),
                        _buildInteractiveRatingRow('Price', controller.ratingPrice),
                        const SizedBox(height: 16),
                        _buildInteractiveRatingRow('Speed', controller.ratingSpeed),
                        const SizedBox(height: 16),
                        _buildInteractiveRatingRow('Overall', controller.ratingOverall),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Feedback area
                    const Text(
                      'Tell others how it went',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.5,
                        color: figmaTextDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3FE),
                        border: Border.all(color: figmaBorder, width: 1),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: TextField(
                        controller: controller.feedbackController,
                        maxLines: null,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: figmaTextDark,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Your experience helps other car owners...',
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Primary submit & cancel actions
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: figmaBlue,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                        ),
                        onPressed: () => controller.submitReview(booking.providerName),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Maybe Later',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: figmaTextMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveRatingRow(String categoryName, RxInt ratingValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Category Label
        Text(
          categoryName,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.5,
            color: figmaTextDark,
          ),
        ),
        // Star widgets selector
        Obx(() => Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isFilled = starIndex <= ratingValue.value;
                return GestureDetector(
                  onTap: () => ratingValue.value = starIndex,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isFilled ? figmaBlue : figmaTextMuted,
                      size: 22,
                    ),
                  ),
                );
              }),
            )),
      ],
    );
  }
}
