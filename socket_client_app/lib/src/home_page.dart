import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:socket_client_app/src/top_level_providers.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _channelStream = useProvider(channelStreamProvider);
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: _channelStream.when(
            data: (data) {
              final int count = jsonDecode('$data')['value'] as int;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Count: $count',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () =>
                            context.read(channelServiceProvider).minus(),
                        child: Icon(Icons.remove),
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        onPressed: () =>
                            context.read(channelServiceProvider).plus(),
                        child: Icon(Icons.add),
                      ),
                    ],
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
      ),
    );
  }
}
