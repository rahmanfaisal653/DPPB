import 'package:flutter/material.dart';

class SidebarInfoBox extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final String buttonText;
  final bool filled;

  const SidebarInfoBox({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.buttonText,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: filled ? Colors.teal : Colors.white,
              foregroundColor: filled ? Colors.white : Colors.teal,
            ),
            onPressed: () {},
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}
