// ignore_for_file: unused_local_variable, unnecessary_null_comparison, avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/websocket_response.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/models/chat_model.dart';
import 'package:grocipe/ui/provider/wesocket_provider.dart';
import 'package:grocipe/ui/screens/chat_screen/widget/chat_bubbles.dart';
import 'package:grocipe/ui/screens/chat_screen/widget/reply_chat_bubble.dart';
import 'package:grocipe/ui/screens/chat_screen/widget/typing_indicator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController animationController;
  TextEditingController messageController = TextEditingController();
  List<File> selectedImages = [];
  WebSocketResponse? suggestedMessages;
  String? reply;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(webSocketServiceProvider.notifier)
          .connect(HiveFunction.getUser().accessToken);
      jumptoBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  jumptoBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void handleSlide(String chat) {
    setState(() {
      reply = chat;
    });
  }

  void sendMessage() async {
    if (messageController.text.trim().isEmpty && selectedImages.isEmpty) return;

    final webSocketService = ref.read(webSocketServiceProvider.notifier);
    Uint8List? imageBytes;

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        webSocketService.unsentImages.addAll(selectedImages);
        selectedImages.clear();
      });
    }
    webSocketService.sendMessage(
      reply != null
          ? "${reply!}\n${messageController.text}"
          : messageController.text,
      // imageBytes: imageBytes,
    );

    setState(() {
      reply = null;
      messageController.clear();
      jumptoBottom();
    });
  }

  Future<void> pickImage() async {
    try {
      final result = await ImageUtils.pickImage();
      if (result != null) {
        final bytes = await result.readAsBytes();
        img.Image? decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          img.Image resizedImage = img.copyResize(decodedImage, width: 500);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);
          final compressedImageFile =
              await _saveCompressedImage(compressedBytes);
          setState(() {
            selectedImages.add(compressedImageFile);
          });
        }
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<File> _saveCompressedImage(List<int> bytes) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File('${tempDir.path}/$fileName');

    try {
      await file.writeAsBytes(bytes);
      print(' saving image: $file');
      return file;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }

  void removeUnsentImage(File imageBytes) {
    final webSocketService = ref.read(webSocketServiceProvider.notifier);
    webSocketService.removeUnsentImage(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    var messages = ref.watch(webSocketServiceProvider);
    bool isLoading = ref.watch(webSocketServiceProvider.notifier).isLoading;

    var unsentImages = ref.read(webSocketServiceProvider.notifier).unsentImages;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumptoBottom();
    });

    final webSocketService = ref.watch(webSocketServiceProvider.notifier);
    final dailyUsage = webSocketService.dailyUsage;
    final dailyUsageRemain = webSocketService.dailyUsageRemain;

    double progressValue = dailyUsageRemain / dailyUsage;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: const AppBackButton(),
        centerTitle: true,
        title: SizedBox(
          width: 120,
          child: Row(
            children: [
              SvgRenderWidget(
                svgPath: "assets/svgs/chat_.svg",
                color: context.colors.black,
              ),
              const Gap(10),
              const Text("Grocipe AI")
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(40.0), // Height of the progress indicator
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Daily prompts used $dailyUsageRemain / $dailyUsage"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
          width: double.infinity,
          child: Column(
            children: [
              ...messages.asMap().entries.map((entry) {
                int index = entry.key;
                var message = entry.value;

                bool isLast = index == messages.length - 1;

                if (message.type == 'sent') {
                  jumptoBottom();
                  return Column(
                    children: [
                      ChatBubble(
                        chat: ChatModel(
                          message: message.preMessage ?? "",
                          isMe: true,
                        ),
                        isMe: true,
                        handleSlide: handleSlide,
                        image: message.images,
                        isLast: isLast,
                      ),
                    ],
                  );
                } else {
                  suggestedMessages = message;
                  // if (message.done == true) {
                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  // }
                  jumptoBottom();
                  return ChatBubble(
                    chat: ChatModel(
                      message: message.preMessage ?? "",
                      isMe: false,
                      response: message,
                    ),
                    isMe: false,
                    textController: messageController,
                    handleSlide: handleSlide,
                    isLast: isLast,
                  );
                }
              }).toList(),
              if (isLoading)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TypingIndicator(),
                    Spacer(),
                  ],
                ),
              const Gap(50)
            ],
          ),
        ),
      ),
      bottomSheet: buildBottomSheet(suggestedMessages?.suggestedMessages ?? []),
    );
  }

  Widget buildBottomSheet(List<SuggestedMessage>? suggestedMessages) {
    return SafeArea(
      maintainBottomViewPadding: true,
      minimum: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: reply != null ? 8 : 0, vertical: reply != null ? 4 : 0),
        decoration: BoxDecoration(
          color: reply != null ? Colors.grey.shade200 : null,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (suggestedMessages!.isNotEmpty) ...[
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestedMessages.length,
                  itemBuilder: (context, index) {
                    final suggestedMessage = suggestedMessages[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 1.0, right: 8), // Adjust spacing as needed
                      child: ActionChip(
                        label: Text(
                          suggestedMessage.message ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        backgroundColor: context.primaryColor.withOpacity(.2),
                        onPressed: () {
                          messageController.text =
                              suggestedMessage.message ?? "";
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            const Gap(10),
            if (reply != null)
              ReplyChatBubble(
                chat: reply!,
                onCancel: () {
                  setState(() {
                    reply = null;
                  });
                },
              ),
            selectedImages.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: context.primaryColor.withOpacity(.2),
                            width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (selectedImages.isNotEmpty) ...[
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.file(
                                            selectedImages[index],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height:
                                                200, // Adjust height as needed
                                          ),
                                        ),
                                        Positioned(
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedImages.remove(
                                                      selectedImages[index]);
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    child: Icon(
                                                      Icons.close_rounded,
                                                      size: 20,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: messageController,
                            maxLines: 3,
                            minLines: 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 20),
                              hintText: "Write a message...",
                              filled: true,
                              border: selectedImages.isNotEmpty
                                  ? InputBorder.none
                                  : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 2),
                                      gapPadding: 0,
                                    ),
                              enabledBorder: selectedImages.isNotEmpty
                                  ? InputBorder.none
                                  : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade500,
                                          width: 2),
                                      gapPadding: 0,
                                    ),
                              focusedBorder: selectedImages.isNotEmpty
                                  ? InputBorder.none
                                  : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: context.primaryColor
                                              .withOpacity(.2),
                                          width: 2),
                                      gapPadding: 0,
                                    ),
                              prefixIcon: IconButton(
                                onPressed: pickImage,
                                icon: const Icon(
                                  Icons.image_sharp,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: sendMessage,
                                icon: const Icon(
                                  Icons.send,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : TextField(
                    controller: messageController,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 20),
                      hintText: "Write a message...",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        gapPadding: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.grey.shade500, width: 2),
                        gapPadding: 0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: context.primaryColor.withOpacity(.2),
                            width: 2),
                        gapPadding: 0,
                      ),
                      prefixIcon: IconButton(
                        onPressed: pickImage,
                        icon: const Icon(
                          Icons.image_sharp,
                          size: 20,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(
                          Icons.send,
                          size: 20,
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
