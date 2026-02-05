import 'package:flutter/material.dart';

import 'core/router.dart';
import 'core/theme.dart';

class EventsiaApp extends StatelessWidget {
  const EventsiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Eventsia',
      debugShowCheckedModeBanner: false,
      theme: EventsiaTheme.theme,
      routerConfig: router,
    );
  }
}
