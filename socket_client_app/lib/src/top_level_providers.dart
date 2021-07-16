import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

/// Creates a WebSocketChannel connected to the server
final _channelProvider = Provider.autoDispose<IOWebSocketChannel>((ref) {
  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'),
  );
  ref.onDispose(() => channel.sink.close(status.goingAway));
  return channel;
});

/// Returns the stream of data sent from the channel
final channelStreamProvider =
    StreamProvider.autoDispose((ref) => ref.watch(_channelProvider).stream);

/// Send data to the channel sink
final addToSinkProvider = Provider.autoDispose.family<void, dynamic>((ref, data) {
  final channel = ref.watch(_channelProvider);
  return channel.sink.add(data);
});