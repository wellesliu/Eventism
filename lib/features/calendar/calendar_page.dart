import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

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

        // Count upcoming events this month
        final now = DateTime.now();
        final monthStart = DateTime(_focusedDay.year, _focusedDay.month, 1);
        final monthEnd = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
        final monthEvents = allEvents.where((e) {
          final date = e.startDateTime;
          if (date == null) return false;
          return date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
              date.isBefore(monthEnd.add(const Duration(days: 1)));
        }).length;

        return Column(
          children: [
            // Hero header
            _buildHeader(context, isMobile, monthEvents),
            // Main content
            Expanded(
              child: isMobile
                  ? _buildMobileLayout(eventMap, selectedDayEvents)
                  : _buildDesktopLayout(eventMap, selectedDayEvents),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, int monthEventCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 24 : 32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064E3B),
            EventismTheme.primaryDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Calendar',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse events by date and plan your schedule',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
          ),
          const SizedBox(height: 20),
          // Stats row
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildStatChip(
                icon: Icons.event,
                label: '$monthEventCount events this month',
              ),
              _buildStatChip(
                icon: Icons.today,
                label: DateFormat('MMMM yyyy').format(_focusedDay),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    Map<DateTime, List<Event>> eventMap,
    List<Event> selectedDayEvents,
  ) {
    return Column(
      children: [
        // Calendar card
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: EventismTheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildCalendar(eventMap),
          ),
        ),
        // Events list
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar card
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: EventismTheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildCalendar(eventMap, large: true),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Events sidebar
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: EventismTheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildEventList(selectedDayEvents),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(Map<DateTime, List<Event>> eventMap, {bool large = false}) {
    return TableCalendar<Event>(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      rowHeight: large ? 60 : 48,
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
        setState(() => _focusedDay = focusedDay);
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        cellMargin: const EdgeInsets.all(4),
        defaultTextStyle: TextStyle(
          fontSize: large ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: EventismTheme.textPrimary,
        ),
        weekendTextStyle: TextStyle(
          fontSize: large ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: EventismTheme.textPrimary,
        ),
        todayDecoration: BoxDecoration(
          color: EventismTheme.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        todayTextStyle: TextStyle(
          color: EventismTheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: large ? 16 : 14,
        ),
        selectedDecoration: BoxDecoration(
          color: EventismTheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: large ? 16 : 14,
        ),
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        markerDecoration: const BoxDecoration(
          color: EventismTheme.cta,
          shape: BoxShape.circle,
        ),
        markerSize: large ? 8 : 6,
        markersMaxCount: 3,
        markersAlignment: Alignment.bottomCenter,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        formatButtonShowsNext: false,
        formatButtonDecoration: BoxDecoration(
          color: EventismTheme.background,
          border: Border.all(color: EventismTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        formatButtonTextStyle: const TextStyle(
          color: EventismTheme.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: large ? 20 : 18,
          fontWeight: FontWeight.w700,
          color: EventismTheme.textPrimary,
        ),
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: EventismTheme.textSecondary,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: EventismTheme.textSecondary,
        ),
        headerPadding: EdgeInsets.symmetric(
          vertical: large ? 20 : 12,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: EventismTheme.textMuted,
          fontSize: large ? 14 : 12,
          fontWeight: FontWeight.w600,
        ),
        weekendStyle: TextStyle(
          color: EventismTheme.textMuted,
          fontSize: large ? 14 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final normalized = DateTime(day.year, day.month, day.day);
          final hasEvents = eventMap[normalized]?.isNotEmpty ?? false;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: hasEvents
                    ? EventismTheme.cta.withValues(alpha: 0.08)
                    : null,
                borderRadius: BorderRadius.circular(12),
                border: hasEvents
                    ? Border.all(
                        color: EventismTheme.cta.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: large ? 16 : 14,
                    fontWeight: hasEvents ? FontWeight.w600 : FontWeight.w500,
                    color: hasEvents
                        ? EventismTheme.cta
                        : EventismTheme.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          return Positioned(
            bottom: 4,
            child: Container(
              width: events.length > 1 ? 20 : 8,
              height: 4,
              decoration: BoxDecoration(
                color: EventismTheme.cta,
                borderRadius: BorderRadius.circular(2),
              ),
              child: events.length > 1
                  ? Center(
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    final dateFormat = DateFormat(AppConstants.timeFormat);

    if (_selectedDay == null) {
      return _buildEmptyState(
        icon: Icons.touch_app,
        title: 'Select a Date',
        subtitle: 'Tap on any date to see events',
      );
    }

    if (events.isEmpty) {
      return Column(
        children: [
          _buildDateHeader(),
          Expanded(
            child: _buildEmptyState(
              icon: Icons.event_busy,
              title: 'No Events',
              subtitle: 'Nothing scheduled for this date',
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildDateHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Material(
                    color: EventismTheme.background,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => context.go('/event/${event.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: EventismTheme.border),
                        ),
                        child: Row(
                          children: [
                            // Time column
                            Container(
                              width: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    EventismTheme.primary,
                                    EventismTheme.primaryDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    event.startDateTime != null
                                        ? DateFormat('h').format(event.startDateTime!)
                                        : '--',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    event.startDateTime != null
                                        ? DateFormat('a').format(event.startDateTime!).toLowerCase()
                                        : '',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Event info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.name,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: EventismTheme.textMuted,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          event.locationShort,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: EventismTheme.textSecondary,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (event.tags.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: event.tags.take(2).map((tag) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: EventismTheme.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            tag,
                                            style: const TextStyle(
                                              color: EventismTheme.primary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: EventismTheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: EventismTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EventismTheme.background,
        border: Border(
          bottom: BorderSide(color: EventismTheme.border),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EventismTheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('d').format(_selectedDay!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(_selectedDay!).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(_selectedDay!),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  DateFormat('MMMM d, yyyy').format(_selectedDay!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: EventismTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: EventismTheme.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: EventismTheme.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: EventismTheme.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
