import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

final channelProvider = Provider.autoDispose<IOWebSocketChannel>((ref) {
  final channel = IOWebSocketChannel.connect(
    Uri.parse('ws://localhost:3000'),
  );
  ref.onDispose(() => channel.sink.close(status.goingAway));
  return channel;
});

final channelStreamProvider =
    StreamProvider.autoDispose((ref) => ref.watch(channelProvider).stream);
