import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('robust_websocket');

class RobustWebsocket with ChangeNotifier {
  Future<void> _reconnect() async {
    log.warning('websocket close code ${_channel!.closeCode}');
    log.warning('websocket close reason ${_channel!.closeReason}');

    isAlive = false;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 5));

    _connect();
  }

  RobustWebsocket({required this.onData}) {
    _connect();
  }

  bool isAlive = false;
  void Function(String) onData;

  IOWebSocketChannel? _channel;

  void _connect() {
    log.info('Connecting to server');

    _channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.113/ws'),
            pingInterval: const Duration(milliseconds: 500));
    _channel!.stream.listen((data) {
      onData(data);

      isAlive = true;
      notifyListeners();
    }, onError: (Object e) {
      final ex = e as WebSocketChannelException;
      log.warning('websocket error: ${ex.message}');
    }, onDone: _reconnect);
  }

  void sendMessage(String s) {
    _channel?.sink.add(s);
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
