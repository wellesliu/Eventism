import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/event.dart';
import '../../data/providers/events_provider.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return eventsAsync.when(
      data: (allEvents) {
        // Build event map for calendar
        final eventMap = <DateTime, List<Event>>{};
        for (final event in allEvents) {
          final date = event.startDateTime;
          if (date != null) {
            final normalized = DateTime(date.year, date.month, date.day);
            eventMap.putIfAbsent(normalized, () => []).add(event);
          }
        }

        // Get events for selected day
        final selectedDayEvents = _selectedDay != null
            ? eventMap[DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                )] ??
                []
            : <Event>[];

        return isMobile
            ? _buildMobileLayout(eventMap, selectedDayEvents)
            : _buildDesktopLayout(eventMap, selectedDayEvents);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildMobileLayout(
    Map<DateTime, List<Event>> eventMap,
    List<Event> selectedDayEvents,
  ) {
    return Column(
      children: [
        _buildCalendar(eventMap),
        const Divider(height: 1),
        Expanded(
          child: _buildEventList(selectedDayEvents),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    Map<DateTime, List<Event>> eventMap,
    List<Event> selectedDayEvents,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: EventismTheme.surface,
            child: _buildCalendar(eventMap),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: _buildEventList(selectedDayEvents),
        ),
      ],
    );
  }

  Widget _buildCalendar(Map<DateTime, List<Event>> eventMap) {
    return TableCalendar<Event>(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) =>
          _selectedDay != null && isSameDay(_selectedDay, day),
      eventLoader: (day) {
        final normalized = DateTime(day.year, day.month, day.day);
        return eventMap[normalized] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() => _calendarFormat = format);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: const TextStyle(color: EventismTheme.textPrimary),
        todayDecoration: BoxDecoration(
          color: EventismTheme.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: EventismTheme.primary,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: const BoxDecoration(
          color: EventismTheme.primary,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: EventismTheme.cta,
          shape: BoxShape.circle,
        ),
        markerSize: 6,
        markersMaxCount: 3,
      ),
      headerStyle: HeaderStyle(
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: EventismTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        titleCentered: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: EventismTheme.textPrimary,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          return Positioned(
            bottom: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                events.length.clamp(0, 3),
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: const BoxDecoration(
                    color: EventismTheme.cta,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    final dateFormat = DateFormat(AppConstants.timeFormat);

    if (_selectedDay == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 48,
              color: EventismTheme.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Select a date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: EventismTheme.textMuted,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap on a date to see events',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: EventismTheme.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No events',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: EventismTheme.textMuted,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMMM d, yyyy').format(_selectedDay!),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(_selectedDay!),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${events.length} event${events.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                child: InkWell(
                  onTap: () => context.go('/event/${event.id}'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Time badge
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: EventismTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            event.startDateTime != null
                                ? dateFormat.format(event.startDateTime!)
                                : '--:--',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: EventismTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Event info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.locationShort,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: EventismTheme.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
