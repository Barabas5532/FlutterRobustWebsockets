import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('robust_websocket');

class RobustWebsocket with ChangeNotifier {
  RobustWebsocket() {
    _channel.stream.listen((data) {
      lastMessage = data;
      notifyListeners();
    }, onError: (Object e) {
      final ex = e as WebSocketChannelException;
      log.warning('websocket error: ${ex.message}');
    }, onDone: () {
      log.warning('websocket close code ${_channel.closeCode}');
      log.warning('websocket close reason ${_channel.closeReason}');
    });
  }

  String lastMessage = '';

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.1.113/ws'),
  );

  void sendMessage(String s) {
    _channel.sink.add(s);
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
