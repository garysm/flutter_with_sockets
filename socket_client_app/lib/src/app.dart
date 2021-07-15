import 'package:flutter/material.dart';
import 'package:socket_client_app/src/home_page.dart';

class SocketsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
