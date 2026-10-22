import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/models/chat_model.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:grocipe/helper/size_config/size_config.dart';

class ChatBubble extends StatelessWidget {
  final ChatModel chat;
  final bool isMe;
  final Function(String preMessage) handleSlide;
  final List<File>? image;
  final Function()? onCancel;
  final bool isLast;
  final TextEditingController? textController;

  const ChatBubble({
    Key? key,
    required this.chat,
    required this.isMe,
    required this.handleSlide,
    this.image,
    this.isLast = false,
    this.onCancel,
    this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bubbles = [];

    // Main message bubble with combined content
    String combinedMessage = chat.message;
    if (chat.response?.listDetails != null) {
      String bulletPoints = chat.response!.listDetails!
          .where((detail) => detail.url == null || detail.url!.isEmpty)
          .map((detail) => "   • ${detail.nameOrDetails ?? ""}")
          .join("\n");

      if (bulletPoints.isNotEmpty) {
        combinedMessage += "\n$bulletPoints";
      }
    }
    if ((chat.response?.postMessage ?? "").isNotEmpty) {
      combinedMessage += "\n${chat.response?.postMessage ?? ""}";
    }

    if (combinedMessage.isNotEmpty) {
      bubbles.add(_buildBubble(
        context,
        combinedMessage,
        isMe,
      ));
    }

    // List detail bubbles with URL
    if (chat.response?.listDetails != null) {
      for (var detail in chat.response!.listDetails!) {
        if (detail.url != null && detail.url!.isNotEmpty) {
          bubbles.add(_buildBubble(context, "", isMe, null, detail.url));
        }
      }
    }

    // Unsent image bubble
    if (image != null) {
      for (var imageData in image!) {
        bubbles.add(_buildImageBubble(context, imageData));
      }
    }
    return Column(
      children: bubbles,
    );
  }

  Widget _buildBubble(BuildContext context, String text, bool isMe,
      [File? image, String? url]) {
    ValueNotifier<double> slideAnimationValue = ValueNotifier<double>(0);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          slideAnimationValue.value += details.primaryDelta! / 300.0;
        }
      },
      onHorizontalDragEnd: (details) {
        if (slideAnimationValue.value > 0.5) {
          String preMessage;
          if (url != null) {
            preMessage = url;
          } else if (image != null) {
            preMessage = "Image Bubble";
          } else {
            preMessage = text;
          }
          handleSlide(preMessage);
        }
        slideAnimationValue.value = 0;
      },
      child: ValueListenableBuilder<double>(
        valueListenable: slideAnimationValue,
        builder: (context, value, _) {
          return Transform.translate(
            offset: Offset(value * 100, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Theme.of(context).primaryColor
                            : context.colors.greyDecor,
                        borderRadius: isMe
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 10,
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (image != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ImageRenderWidget.file(
                                  file: image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (text.isNotEmpty)
                            Text(
                              text,
                              textAlign:
                                  isMe ? TextAlign.right : TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: isMe
                                        ? Colors.white
                                        : context.colors.black,
                                  ),
                            ),
                          if (url != null)
                            AnyLinkPreview(
                              link: url,
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              showMultimedia: true,
                              boxShadow: null,
                              bodyMaxLines: 5,
                              bodyTextOverflow: TextOverflow.ellipsis,
                              titleStyle: TextStyle(
                                color:
                                    isMe ? Colors.white : context.colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              bodyStyle: TextStyle(
                                color:
                                    isMe ? Colors.white : context.colors.black,
                                fontSize: 12,
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
        },
      ),
    );
  }

  Widget _buildImageBubble(BuildContext context, File image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 40,
                maxHeight: SizeConfig.heightOf(20),
                maxWidth: MediaQuery.of(context).size.width * 4.75,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ImageRenderWidget.file(
                  file: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
