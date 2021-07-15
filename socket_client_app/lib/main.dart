import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_client_app/src/utils/provider_logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() => runApp(
      ProviderScope(
        child: MyApp(),
        observers: [
          ProviderLogger(),
        ],
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: MyHomePage(),
    );
  }
}

final channelProvider = Provider.autoDispose<IOWebSocketChannel>((ref) {
  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'),
  );
  ref.onDispose(() => channel.sink.close(status.goingAway));
  return channel;
});

final channelStreamProvider =
    StreamProvider.autoDispose((ref) => ref.watch(channelProvider).stream);

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = useTextEditingController();
    final IOWebSocketChannel _channel = useProvider(channelProvider);
    final _channelStream = useProvider(channelStreamProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            SizedBox(height: 24),
            _channelStream.when(
              data: (data) {
                return Text('${data}');
              },
              loading: () => Text('No Data'),
              error: (obj, stack) => Text('$obj'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _sendMessage(text: _controller.text, channel: _channel),
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage(
      {required String text, required IOWebSocketChannel channel}) {
    if (text.isNotEmpty) {
      channel.sink.add(text);
    }
  }
}
