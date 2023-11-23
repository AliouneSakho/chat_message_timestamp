import 'package:example/enums/sending_status.dart';

class Message {
  final String id;
  final String userName;
  final String message;
  final DateTime sentAt;
  final bool isFromMe;
  SendingStatus sendingStatus;

  Message({
    required this.id,
    required this.userName,
    required this.message,
    required this.sentAt,
    required this.isFromMe,
    required this.sendingStatus,
  });

  @override
  bool operator ==(covariant Message other) =>
      runtimeType == other.runtimeType &&
      id == other.id &&
      userName == other.userName &&
      message == other.message &&
      sentAt == other.sentAt &&
      isFromMe == other.isFromMe &&
      sendingStatus == other.sendingStatus;

  @override
  int get hashCode => Object.hashAll([
        id,
        userName,
        message,
        sentAt,
        isFromMe,
        sendingStatus,
      ]);

  void updateSendingStatus(SendingStatus status) {
    sendingStatus = status;
  }
}
