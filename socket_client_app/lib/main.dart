import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socket_client_app/src/app.dart';
import 'package:socket_client_app/src/utils/provider_logger.dart';

void main() => runApp(
      ProviderScope(
        child: SocketsApp(),
        observers: [
          ProviderLogger(),
        ],
      ),
    );
