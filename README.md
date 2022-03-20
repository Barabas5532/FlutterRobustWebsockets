# robust_websocket

Goals:
 - [x] Display the server connection status in real time
 - [x] Update the UI within 10s when the server disconnects or reconnects
 - [x] Works when server is down during start-up, and comes alive later
 - [x] Works when the server dies and restarts after we have connected
 - [ ] Works on all platforms

Currently only non-web platforms are supported, as some features are missing on
the web implementation of the dart WebSocket client.

Dart has two separate implementations for a WebSocket client:
 - [dart:io]: * Not supported on web. * This is the one we are using.
 - [dart:html]: * ONLY supported on web. * Missing the `pingInterval` and
   construct from raw socket features.

[dart:io]: https://api.dart.dev/stable/2.16.1/dart-io/WebSocket-class.html
[dart:html]: https://api.dart.dev/stable/2.16.1/dart-html/WebSocket-class.html

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
