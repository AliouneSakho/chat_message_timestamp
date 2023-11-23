import 'package:example/enums/sending_status.dart';
import 'package:flutter/material.dart' show Colors, Icon, Icons;

extension SendingStatusExtension on SendingStatus {
  Icon get icon {
    switch (this) {
      case SendingStatus.sending:
        return const Icon(Icons.watch_later_outlined);
      case SendingStatus.sent:
        return const Icon(Icons.check);
      case SendingStatus.receivedByUser:
        return const Icon(Icons.done_all);
      case SendingStatus.seenByUser:
        return const Icon(
          Icons.done_all,
          color: Colors.blue,
        );
      default:
        return const Icon(Icons.error);
    }
  }
}
