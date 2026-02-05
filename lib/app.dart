import 'package:flutter/material.dart';

import 'core/router.dart';
import 'core/theme.dart';

class EventismApp extends StatelessWidget {
  const EventismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Eventism',
      debugShowCheckedModeBanner: false,
      theme: EventismTheme.theme,
      routerConfig: router,
    );
  }
}
