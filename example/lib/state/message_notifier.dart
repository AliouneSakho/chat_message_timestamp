import 'package:example/enums/sending_status.dart';
import 'package:example/models/message.dart';
import 'package:flutter/material.dart';

class MessageNotifier extends ValueNotifier<Set<Message>> {
  MessageNotifier._sharedInstance() : super(messages);
  static final _shared = MessageNotifier._sharedInstance();
  factory MessageNotifier() => _shared;

  void sendMessage(String message) {
    final id = '${value.length + 1}';
    final newMessage = Message(
      id: id,
      userName: 'Vous',
      message: message,
      sentAt: DateTime.now(),
      isFromMe: true,
      sendingStatus: SendingStatus.sending,
    );
    value.add(newMessage);
    notifyListeners();
    updateSendingStatusAndGenerateResponse(id);
  }

  void updateSendingStatusAndGenerateResponse(String id) {
    Future.delayed(const Duration(seconds: 1), () {
      value
          .where((element) => element.id == id)
          .first
          .updateSendingStatus(SendingStatus.seenByUser);
      notifyListeners();
      autoGenarateResponse();
    });
  }

  void autoGenarateResponse() {
    Future.delayed(const Duration(milliseconds: 500), () {
      final id = '${value.length + 1}';

      final newMessage = Message(
        id: id,
        userName: 'John Doe',
        message:
            'Auto genrated response number ${value.where((element) => element.isFromMe == false).length + 1}',
        sentAt: DateTime.now(),
        isFromMe: false,
        sendingStatus: SendingStatus.seenByUser,
      );
      value.add(newMessage);
      notifyListeners();
    });
  }
}

Set<Message> messages = {
  Message(
    id: '1',
    userName: 'John Doe',
    message: 'Hi, how are you?',
    sentAt: DateTime.now(),
    isFromMe: false,
    sendingStatus: SendingStatus.seenByUser,
  ),
  Message(
    id: '2',
    userName: 'Vous',
    message: 'I\'m good, thank you! How about you?',
    sentAt: DateTime.now().add(const Duration(minutes: 5)),
    isFromMe: true,
    sendingStatus: SendingStatus.seenByUser,
  ),
  Message(
    id: '3',
    userName: 'John Doe',
    message: 'All good on my end too.',
    sentAt: DateTime.now().add(const Duration(minutes: 10)),
    isFromMe: false,
    sendingStatus: SendingStatus.seenByUser,
  ),
  Message(
    id: '4',
    userName: 'Vous',
    message: 'Cool! Any plans for the weekend?',
    sentAt: DateTime.now().add(const Duration(minutes: 15)),
    isFromMe: true,
    sendingStatus: SendingStatus.seenByUser,
  ),
  Message(
    id: '5',
    userName: 'John Doe',
    message: 'I\'m so excited for the weekend!'
        'I\'ve been looking forward to it all week,'
        ' and I\'ve got a fun-filled plan that I can\'t wait to share with you. On Friday night,'
        'I\'m thinking of heading to the local farmers market to pick up some fresh produce for a delicious meal.'
        'Then, on Saturday, I\'m planning to catch up with some old friends at the park for a game of frisbee and some good old-fashioned conversation.'
        'And on Sunday, I\'m going to indulge in some much-needed relaxation time at home, maybe with a good book and a warm cup of tea.'
        'I\'m so glad to have some time to unwind and recharge before the start of another week. What are your plans for the weekend?',
    sentAt: DateTime.now().add(const Duration(minutes: 20)),
    isFromMe: false,
    sendingStatus: SendingStatus.seenByUser,
  ),
};
