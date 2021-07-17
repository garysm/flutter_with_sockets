import 'dart:convert';

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
      body: Container(
        padding: EdgeInsets.all(20),
        child: _channelStream.when(
          data: (data) {
            final List<dynamic> messages = json.decode('$data') as List;
            return ListView(
              children: <Widget>[
                Form(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: messages.map((message) => Text('$message')).toList(),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
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
