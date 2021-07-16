import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:socket_client_app/src/top_level_providers.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = useTextEditingController();
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
              data: (data) => Text('$data'),
              loading: () => Text('No Data'),
              error: (obj, stack) => Text('$obj'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final text = _controller.text;
          if (text.isNotEmpty) {
            return context.read(addToSinkProvider(text));
          }
        },
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }
}
