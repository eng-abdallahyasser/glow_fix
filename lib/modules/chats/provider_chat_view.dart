import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/app_colors.dart';
import 'chats_controller.dart';

class ProviderChatView extends StatefulWidget {
  const ProviderChatView({super.key});

  @override
  State<ProviderChatView> createState() => _ProviderChatViewState();
}

class _ProviderChatViewState extends State<ProviderChatView> {
  final ChatsController controller = Get.find<ChatsController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to bottom after initial layout
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    
    // Automatically scroll to bottom when new messages arrive
    controller.activeMessages.listen((_) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottomAnimated());
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _scrollToBottomAnimated() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.chatBackground,
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 20.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: AppColors.chatBackground,
            elevation: 0,
            leadingWidth: 48,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9999),
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.inactiveLabel,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                // Profile Avatar Container
                Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=150&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Voltline Auto Electric',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191B23),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'ONLINE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: AppColors.chatStatusGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: Container(
                  width: 20,
                  height: 32,
                  margin: const EdgeInsets.only(right: 20),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9999),
                      onTap: () {},
                      child: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.inactiveLabel,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Subtle precision decorative background
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: const PrecisionBackgroundPainter(),
              ),
            ),
          ),
          
          // Main Chat Canvas
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  final messages = controller.activeMessages;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length + 1, // +1 for date divider
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildDateDivider();
                      }
                      final msg = messages[index - 1];
                      return _buildMessageBubble(msg);
                    },
                  );
                }),
              ),
              
              // Bottom Input Bar
              _buildBottomInputBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.chatDividerBg,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: const Text(
          'Today',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.chatDividerText,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message Bubble Background
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, // Up to 75% width
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: msg.isUser ? AppColors.chatBubbleUser : AppColors.chatBubbleProvider,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000), // rgba(0,0,0,0.05)
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: msg.isUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: msg.isUser ? AppColors.chatTextUser : AppColors.chatTextProvider,
                      height: 1.5,
                    ),
                  ),
                  if (msg.isServiceCard) ...[
                    const SizedBox(height: 12),
                    _buildServiceCard(msg.serviceTitle ?? 'Service check', msg.serviceStatus ?? 'PREPPED'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),
            
            // Timestamp and Read Receipts
            Padding(
              padding: msg.isUser ? const EdgeInsets.only(right: 8.0) : const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg.time,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.chatTextMuted,
                    ),
                  ),
                  if (msg.isUser) ...[
                    const SizedBox(width: 4),
                    Icon(
                      msg.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                      size: 14,
                      color: msg.isRead ? AppColors.chatBubbleUser : AppColors.chatTextMuted,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String status) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: AppColors.chatServiceCardBg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.chatBorderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.chatServiceIconBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.electrical_services_rounded,
              color: AppColors.chatServiceIcon,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          
          // Service Title and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191B23),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.chatStatusGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.chatBackground,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attach Button
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.chatAttachmentBg,
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () {},
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.chatAttachmentIcon,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Input Field
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.chatInputBg,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: TextField(
                  controller: controller.messageInputController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.sendMessage(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Color(0xFF191B23),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFFC3C6D7),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Send Button
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.chatBubbleUser,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000), // rgba(0,0,0,0.05)
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () => controller.sendMessage(),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Background painter for the faint "Precision" grid
class PrecisionBackgroundPainter extends CustomPainter {
  const PrecisionBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC3C6D7).withOpacity(0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Faint grid lines
    const double gridSize = 40.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Faint crosshair symbols for technical alignment
    final techPaint = Paint()
      ..color = AppColors.chatBubbleUser.withOpacity(0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double tickLen = 6.0;
    final List<Offset> centers = [
      Offset(size.width * 0.25, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.25, size.height * 0.75),
      Offset(size.width * 0.75, size.height * 0.75),
    ];

    for (final c in centers) {
      canvas.drawCircle(c, 4.0, techPaint);
      canvas.drawLine(Offset(c.dx - tickLen, c.dy), Offset(c.dx + tickLen, c.dy), techPaint);
      canvas.drawLine(Offset(c.dx, c.dy - tickLen), Offset(c.dx, c.dy + tickLen), techPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
