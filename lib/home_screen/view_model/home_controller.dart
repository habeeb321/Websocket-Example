import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeController extends GetxController {
  final RxString socket = ''.obs;

  @override
  void onInit() {
    socketMessage();
    super.onInit();
  }

  socketMessage([channel]) {
    /// Create the WebSocket channel
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws-feed.pro.coinbase.com'),
    );

    channel.sink.add(
      jsonEncode(
        {
          "type": "subscribe",
          "channels": [
            {
              "name": "ticker",
              "product_ids": [
                "BTC-EUR",
              ]
            }
          ]
        },
      ),
    );

    /// Listen for all incoming data
    channel.stream.listen(
      (data) {
        socket.value = data;
        print(data);
      },
      onError: (error) => print("Error = $error"),
    );
  }
}
