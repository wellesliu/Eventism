import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/providers/events_provider.dart';
import 'widgets/event_header.dart';
import 'widgets/event_info.dart';
import 'widgets/cta_buttons.dart';

class EventDetailPage extends ConsumerWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return eventAsync.when(
      data: (event) {
        if (event == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/browse'),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: EventsiaTheme.textMuted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Event not found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This event may have been removed',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/browse'),
                    child: const Text('Browse Events'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App bar with banner
              SliverAppBar(
                expandedHeight: isMobile ? 200 : 300,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/browse'),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: EventHeader(event: event),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EventInfo(event: event),
                            const SizedBox(height: 24),
                            CtaButtons(event: event),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: EventInfo(event: event),
                            ),
                            const SizedBox(width: 32),
                            SizedBox(
                              width: 300,
                              child: CtaButtons(event: event),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/browse'),
          ),
        ),
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
