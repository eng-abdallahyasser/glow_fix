import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final bool isServiceCard;
  final String? serviceTitle;
  final String? serviceStatus;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isServiceCard = false,
    this.serviceTitle,
    this.serviceStatus,
    this.isRead = false,
  });
}

class ChatThread {
  final String id;
  final String name;
  final RxString message;
  final RxString time;
  final RxInt unreadCount;
  final String imageUrl;
  final bool isOnline;

  ChatThread({
    required this.id,
    required this.name,
    required String message,
    required String time,
    required int unreadCount,
    required this.imageUrl,
    this.isOnline = false,
  })  : message = message.obs,
        time = time.obs,
        unreadCount = unreadCount.obs;
}

class ChatsController extends GetxController {
  // Input Controllers
  final messageInputController = TextEditingController();
  final searchController = TextEditingController();

  // Active chat details (for Voltline)
  final activeMessages = <ChatMessage>[].obs;
  
  // Conversations List
  final allThreads = <ChatThread>[].obs;
  final filteredThreads = <ChatThread>[].obs;
  
  // Search query
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize conversations list exactly matching design specifications
    allThreads.addAll([
      ChatThread(
        id: 'voltline',
        name: 'Voltline Auto Electric',
        message: 'Great, I\'m heading over now. See you soon!',
        time: '10:22 AM',
        unreadCount: 0,
        imageUrl: 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=150&q=80',
        isOnline: true,
      ),
      ChatThread(
        id: 'shine',
        name: 'Shine & Co. Detailing',
        message: 'Hello! Your booking for tomorrow is confirmed.',
        time: '10:45 AM',
        unreadCount: 1,
        imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
        isOnline: true,
      ),
      ChatThread(
        id: 'elite',
        name: 'Elite Engine Works',
        message: 'The brake pad replacement is complete. Would you like us to check the fluid levels as well?',
        time: '2 hours ago',
        unreadCount: 0,
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
        isOnline: false,
      ),
      ChatThread(
        id: 'pristine',
        name: 'Pristine Car Wash',
        message: 'Thank you for choosing Pristine! Your receipt #4920 has been generated.',
        time: 'Yesterday',
        unreadCount: 0,
        imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=150&q=80',
        isOnline: false,
      ),
      ChatThread(
        id: 'glowfix',
        name: 'GlowFix Support',
        message: 'Hi there! How can we help you with your service today?',
        time: '2 days ago',
        unreadCount: 1,
        imageUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=150&q=80',
        isOnline: true,
      ),
      ChatThread(
        id: 'quickfix',
        name: 'QuickFix Tires',
        message: 'We have the Michelin Pilot Sport 4S in stock. Can we schedule your fitting for Monday?',
        time: '3 days ago',
        unreadCount: 0,
        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
        isOnline: false,
      ),
    ]);

    filteredThreads.addAll(allThreads);

    // Initialize active chat messages with Voltline Auto Electric
    activeMessages.addAll([
      ChatMessage(
        text: 'Hello! I see you\'re having issues with your Tesla\'s diagnostic port. I have an opening at 2:00 PM today for a quick inspection. Would that work for you?',
        isUser: false,
        time: '10:15 AM',
      ),
      ChatMessage(
        text: 'That sounds perfect. Do I need to bring anything specific or just the vehicle?',
        isUser: true,
        time: '10:18 AM',
      ),
      ChatMessage(
        text: 'Just the vehicle is fine. I\'ve prepped the diagnostic bay. Here is the service summary for the initial check:',
        isUser: false,
        time: '10:20 AM',
        isServiceCard: true,
        serviceTitle: 'Diagnostic Check',
        serviceStatus: 'PREPPED',
      ),
      ChatMessage(
        text: 'Great, I\'m heading over now. See you soon!',
        isUser: true,
        time: '10:22 AM',
        isRead: true,
      ),
    ]);

    // Setup reactive search
    searchController.addListener(() {
      filterConversations(searchController.text);
    });
  }

  void filterConversations(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredThreads.assignAll(allThreads);
    } else {
      filteredThreads.assignAll(
        allThreads.where((thread) =>
            thread.name.toLowerCase().contains(query.toLowerCase()) ||
            thread.message.value.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    // Current Time
    final now = DateTime.now();
    final timeStr = '${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    // Add User Message
    final newMsg = ChatMessage(
      text: text,
      isUser: true,
      time: timeStr,
      isRead: false,
    );
    activeMessages.add(newMsg);
    
    // Clear input
    messageInputController.clear();

    // Update conversation list item for Voltline
    final voltlineThread = allThreads.firstWhereOrNull((t) => t.id == 'voltline');
    if (voltlineThread != null) {
      voltlineThread.message.value = text;
      voltlineThread.time.value = timeStr;
      
      // Move voltline to the top
      allThreads.remove(voltlineThread);
      allThreads.insert(0, voltlineThread);
      filterConversations(searchQuery.value);
    }

    // Trigger mock auto response
    Timer(const Duration(milliseconds: 1500), () {
      final responseNow = DateTime.now();
      final responseTimeStr = '${responseNow.hour > 12 ? responseNow.hour - 12 : responseNow.hour}:${responseNow.minute.toString().padLeft(2, '0')} ${responseNow.hour >= 12 ? 'PM' : 'AM'}';
      
      final replyMsg = ChatMessage(
        text: 'Sounds great! Drive safe, see you shortly.',
        isUser: false,
        time: responseTimeStr,
      );
      activeMessages.add(replyMsg);

      // Update the user message to be read
      final lastUserMsgIdx = activeMessages.indexWhere((m) => m.isUser && m == newMsg);
      if (lastUserMsgIdx != -1) {
        activeMessages[lastUserMsgIdx] = ChatMessage(
          text: newMsg.text,
          isUser: true,
          time: newMsg.time,
          isRead: true,
          isServiceCard: newMsg.isServiceCard,
          serviceTitle: newMsg.serviceTitle,
          serviceStatus: newMsg.serviceStatus,
        );
      }

      // Update thread
      if (voltlineThread != null) {
        voltlineThread.message.value = 'Sounds great! Drive safe, see you shortly.';
        voltlineThread.time.value = responseTimeStr;
        filterConversations(searchQuery.value);
      }
    });
  }

  void markAsRead(String threadId) {
    final thread = allThreads.firstWhereOrNull((t) => t.id == threadId);
    if (thread != null) {
      thread.unreadCount.value = 0;
    }
  }

  @override
  void onClose() {
    messageInputController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
