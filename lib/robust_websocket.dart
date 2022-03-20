import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('robust_websocket');

class RobustWebsocket with ChangeNotifier {
  Future<void> _reconnect() async {
    log.warning('websocket close code ${_ws!.closeCode}');
    log.warning('websocket close reason ${_ws!.closeReason}');

    isAlive = false;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 5));

    _connect();
  }

  RobustWebsocket({required this.onData, required this.uri}) {
    _connect();
  }

  Uri uri;
  bool isAlive = false;
  void Function(String) onData;

  WebSocket? _ws;

  Future<void> _connect() async {
    log.info('Connecting to server...');

    Socket? socket;
    while (socket == null) {
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 5);
        final request = await client.openUrl('GET', uri);

        request.headers
          ..set('Connection', 'Upgrade')
          ..set('Upgrade', 'websocket')
          ..set('Sec-WebSocket-Key', 'x3JJHMbDL1EzLkh9GBhXDw==')
          ..set('Sec-WebSocket-Version', '13');

        final response = await request.close();
        socket = await response.detachSocket();
      } catch (err) {
        log.warning('Failed to connect to server, retrying...');
        log.warning('$err');
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    log.info('Connected to server');

    isAlive = true;
    notifyListeners();

    _ws = WebSocket.fromUpgradedSocket(socket, serverSide: false);

    _ws!.listen((data) {
      onData(data);
    }, onError: (Object e) {
      log.warning('websocket error: $e');
    }, onDone: _reconnect);

    _ws!.pingInterval = const Duration(seconds: 1);
  }

  void sendMessage(String s) {
    _ws?.add(s);
  }

  @override
  void dispose() {
    _ws?.close(1001);
    super.dispose();
  }
}
