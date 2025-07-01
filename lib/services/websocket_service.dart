import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;

  WebSocketService(this.url);

  Stream<Map<String, dynamic>> connect() {
    _controller = StreamController<Map<String, dynamic>>.broadcast();
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((event) {
      try {
        final data = jsonDecode(event);
        if (data is Map<String, dynamic>) {
          _controller?.add(data);
        }
      } catch (_) {}
    }, onError: (e) {
      _controller?.addError(e);
    }, onDone: () {
      _controller?.close();
    });
    return _controller!.stream;
  }

  void send(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel?.sink.close();
    _controller?.close();
  }

  // For testing: simulate incoming messages
  void simulateMessage(Map<String, dynamic> message) {
    _controller?.add(message);
  }
} 