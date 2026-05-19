import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_fix/core/widgets/top_app_bar.dart';
import '../../core/values/app_colors.dart';
import 'chats_controller.dart';
import 'provider_chat_view.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBackground,
      body: SafeArea(
        child: Column(
          children: [
            const MyTopAppBar(),
            // Search / Filter Input
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Container(
                height: 49,
                decoration: BoxDecoration(
                  color: AppColors.chatInputBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.chatBorderColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.searchController,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.chatBorderColor,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),

            // Conversations List
            Expanded(
              child: Obx(() {
                final threads = controller.filteredThreads;
                if (threads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 48,
                          color: AppColors.textMuted.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No conversations found',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: threads.length,
                  itemBuilder: (context, index) {
                    final thread = threads[index];
                    return _buildChatThread(context, thread);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatThread(BuildContext context, ChatThread thread) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.markAsRead(thread.id);
              // Navigate to the Chat Detail view (Figma screen 2)
              Get.to(
                () => const ProviderChatView(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 250),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with customizable border and online status
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.chatBorderColor,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(thread.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (thread.isOnline)
                        Positioned(
                          right: -1,
                          bottom: -1,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.chatStatusGreen,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.chatBackground,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Text and message body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Time Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(
                                thread.name,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF191B23),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Text(
                                thread.time.value,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.inactiveLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Message snippet & Unread count
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Obx(
                                () => Text(
                                  thread.message.value,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.inactiveLabel,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            // Unread pill badge
                            Obx(() {
                              final count = thread.unreadCount.value;
                              if (count <= 0) return const SizedBox.shrink();
                              return Container(
                                margin: const EdgeInsets.only(left: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.chatBubbleUser,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Item bottom divider border bottom: 1px solid #C3C6D7
        Padding(
          padding: const EdgeInsets.only(left: 92.0, right: 20.0),
          child: Container(
            height: 1,
            color: AppColors.chatBorderColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
