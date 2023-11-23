import 'package:chat_message_timestamp/chat_message_timestamp.dart';
import 'package:chat_message_timestamp/extensions/dateformat_on_datetime.dart';
import 'package:example/extensions/sendingiconextension_on_sendingstatus.dart';
import 'package:example/state/message_notifier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: MessageNotifier(),
                builder: (_, messages, __) => Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(15.0),
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final message = messages.elementAt(index);
                      return Align(
                        alignment: message.isFromMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          constraints:
                              BoxConstraints(maxWidth: size.width * 0.8),
                          decoration: BoxDecoration(
                            color: message.isFromMe
                                ? Colors.pinkAccent.shade200
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                offset: const Offset(0, 0),
                                blurRadius: 9,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: TimestampedChatMessage(
                            text: message.message,
                            sentAt: message.sentAt.formattedTimeHm,
                            maxLines: 4,
                            showMoreTextStyle:
                                const TextStyle(color: Colors.deepPurpleAccent),
                            style: TextStyle(
                              color: message.isFromMe
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                            ),
                            sendingStatusIcon: message.isFromMe
                                ? message.sendingStatus.icon
                                : null,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 15);
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton.filledTonal(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        MessageNotifier().sendMessage(controller.text);
                        controller.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
