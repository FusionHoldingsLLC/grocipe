import 'package:flutter/material.dart';
import 'package:grocipe/helper/utils/context_extension.dart';

class ReplyChatBubble extends StatelessWidget {
  final String chat;
  final VoidCallback onCancel;

  const ReplyChatBubble({
    Key? key,
    required this.chat,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: context.colors.greyDecor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat,
                  style: TextStyle(
                    color: context.colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  chat,
                  style: TextStyle(
                    color: context.colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
