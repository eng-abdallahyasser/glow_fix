import 'package:flutter/material.dart';

class MyTopAppBar extends StatelessWidget {
  const MyTopAppBar({super.key});

  static const Color figmaBg = Color(0xFFFAF8FF);
  static const Color figmaBlue = Color(0xFF004AC6);
  static const Color figmaTextMuted = Color(0xFF434655);
  static const Color figmaShadowColor = Color(0x0D000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: figmaBg,
        boxShadow: [
          BoxShadow(
            color: figmaShadowColor, // rgba(0,0,0,0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo + Brand Title Left Container
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.bolt_rounded,
                color: figmaBlue,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Glow',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: figmaBlue,
                  height: 1.25,
                ),
              ),
            ],
          ),
          // Right Notification Button
          Container(
            width: 32,
            height: 36,
            alignment: Alignment.center,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: figmaTextMuted, // #434655
                size: 20,
              ),
              onPressed: () {
                // Notification action
              },
            ),
          ),
        ],
      ),
    );
  }
}