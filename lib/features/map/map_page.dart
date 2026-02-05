import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/event.dart';
import '../../data/providers/events_provider.dart';
import 'widgets/event_marker.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final _mapController = MapController();
  Event? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsWithCoordinatesProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Stack(
      children: [
        eventsAsync.when(
          data: (events) => FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(
                AppConstants.defaultLatitude,
                AppConstants.defaultLongitude,
              ),
              initialZoom: AppConstants.defaultZoom,
              onTap: (_, __) {
                setState(() => _selectedEvent = null);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.sopivasti.eventsia',
              ),
              MarkerLayer(
                markers: _buildMarkers(events),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error'),
          ),
        ),
        // Legend
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EventsiaTheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Event Locations',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                eventsAsync.when(
                  data: (events) => Text(
                    '${events.length} events with locations',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        // Selected event popup
        if (_selectedEvent != null)
          Positioned(
            bottom: isMobile ? 16 : 32,
            left: isMobile ? 16 : 32,
            right: isMobile ? 16 : null,
            child: _buildEventPopup(context, _selectedEvent!),
          ),
      ],
    );
  }

  List<Marker> _buildMarkers(List<Event> events) {
    // Group events by approximate location to handle clustering
    final markers = <Marker>[];

    for (final event in events) {
      if (event.latitude == null || event.longitude == null) continue;

      // Add small random offset to prevent exact overlaps
      final offset = event.id.hashCode % 100 / 10000;
      final lat = event.latitude! + offset;
      final lng = event.longitude! + (offset * 1.5);

      markers.add(
        Marker(
          point: LatLng(lat, lng),
          width: 40,
          height: 40,
          child: EventMarker(
            event: event,
            isSelected: _selectedEvent?.id == event.id,
            onTap: () {
              setState(() => _selectedEvent = event);
              _mapController.move(
                LatLng(lat, lng),
                AppConstants.markerZoom,
              );
            },
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildEventPopup(BuildContext context, Event event) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Stack(
              children: [
                if (event.bannerUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      event.bannerUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 120,
                        color: EventsiaTheme.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.event,
                          size: 40,
                          color: EventsiaTheme.primary,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => setState(() => _selectedEvent = null),
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: EventsiaTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.locationShort,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/event/${event.id}'),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
