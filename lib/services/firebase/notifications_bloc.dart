import 'dart:async';

class NotificationsBloc {
  NotificationsBloc._internal() {
    _notificationStreamController.onListen = _onListen;
  }

  static final NotificationsBloc instance = NotificationsBloc._internal();

  bool _sendBufferedEvents = true;

  Map<String, dynamic> _bufferedEvent = {};

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationStreamController.stream;

  final _notificationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  _onListen() {
    if (_sendBufferedEvents) {
      _notificationStreamController.sink.add(_bufferedEvent);
      _sendBufferedEvents = false;
    }
  }

  void newNotification(Map<String, dynamic> notification) {
    if (_sendBufferedEvents) {
      _bufferedEvent = notification;
    } else {
      _notificationStreamController.sink.add(notification);
    }
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
