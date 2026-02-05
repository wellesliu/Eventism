import 'dart:convert';
import 'dart:io';

/// Converts eventsia_data.csv to events.json
/// Run with: dart run scripts/convert_csv.dart
void main() async {
  final csvFile = File('eventsia_data.csv');
  if (!csvFile.existsSync()) {
    print('Error: eventsia_data.csv not found');
    exit(1);
  }

  final content = await csvFile.readAsString();
  final events = parseCsv(content);

  final jsonFile = File('assets/events.json');
  await jsonFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(events),
  );

  print('Converted ${events.length} events to assets/events.json');
}

List<Map<String, dynamic>> parseCsv(String content) {
  final events = <Map<String, dynamic>>[];
  final lines = content.split('\n');

  if (lines.isEmpty) return events;

  // Parse header
  final headers = parseRow(lines[0]);

  // Parse data rows (handling multiline fields)
  var currentRow = <String>[];
  var inQuotes = false;
  var currentField = StringBuffer();

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i];

    for (var j = 0; j < line.length; j++) {
      final char = line[j];

      if (char == '"') {
        if (inQuotes && j + 1 < line.length && line[j + 1] == '"') {
          // Escaped quote
          currentField.write('"');
          j++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        currentRow.add(currentField.toString());
        currentField = StringBuffer();
      } else {
        currentField.write(char);
      }
    }

    if (inQuotes) {
      // Field continues to next line
      currentField.write('\n');
    } else {
      // End of row
      currentRow.add(currentField.toString());
      currentField = StringBuffer();

      if (currentRow.length >= headers.length) {
        final event = createEvent(headers, currentRow);
        if (event != null && event['status'] == 'published') {
          events.add(event);
        }
      }
      currentRow = [];
    }
  }

  return events;
}

List<String> parseRow(String line) {
  final fields = <String>[];
  var inQuotes = false;
  var currentField = StringBuffer();

  for (var i = 0; i < line.length; i++) {
    final char = line[i];

    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        currentField.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      fields.add(currentField.toString());
      currentField = StringBuffer();
    } else {
      currentField.write(char);
    }
  }
  fields.add(currentField.toString());

  return fields;
}

Map<String, dynamic>? createEvent(List<String> headers, List<String> values) {
  if (values.isEmpty || values[0].isEmpty) return null;

  final map = <String, dynamic>{};

  for (var i = 0; i < headers.length && i < values.length; i++) {
    final header = headers[i].trim();
    var value = values[i].trim();

    switch (header) {
      case 'id':
      case 'organiser_id':
      case 'name':
      case 'description':
      case 'banner_url':
      case 'location':
      case 'status':
        map[header] = value;
        break;
      case 'tags':
        try {
          map[header] = value.isNotEmpty ? jsonDecode(value) : <String>[];
        } catch (_) {
          map[header] = <String>[];
        }
        break;
      case 'start_date':
      case 'end_date':
      case 'vendor_application_deadline':
      case 'created_at':
      case 'updated_at':
        map[header] = value.isNotEmpty ? value : null;
        break;
      case 'accepts_vendors':
      case 'bear_eventsia_fee':
      case 'vendor_requires_approval':
      case 'enable_vendor_form':
      case 'vendor_form_is_public':
        map[header] = value.toUpperCase() == 'TRUE';
        break;
    }
  }

  // Extract coordinates from location if possible
  map['latitude'] = getLatitude(map['location'] ?? '');
  map['longitude'] = getLongitude(map['location'] ?? '');

  return map;
}

// Approximate coordinates for Australian cities
double? getLatitude(String location) {
  final lower = location.toLowerCase();
  if (lower.contains('sydney')) return -33.8688;
  if (lower.contains('melbourne')) return -37.8136;
  if (lower.contains('brisbane')) return -27.4698;
  if (lower.contains('perth')) return -31.9505;
  if (lower.contains('adelaide')) return -34.9285;
  if (lower.contains('gold coast')) return -28.0167;
  if (lower.contains('canberra')) return -35.2809;
  if (lower.contains('hobart')) return -42.8821;
  if (lower.contains('darwin')) return -12.4634;
  if (lower.contains('newcastle')) return -32.9283;
  if (lower.contains('wollongong')) return -34.4248;
  if (lower.contains('geelong')) return -38.1499;
  if (lower.contains('townsville')) return -19.2590;
  if (lower.contains('cairns')) return -16.9186;
  if (lower.contains('toowoomba')) return -27.5598;
  // Add small random offset to prevent overlapping
  return null;
}

double? getLongitude(String location) {
  final lower = location.toLowerCase();
  if (lower.contains('sydney')) return 151.2093;
  if (lower.contains('melbourne')) return 144.9631;
  if (lower.contains('brisbane')) return 153.0251;
  if (lower.contains('perth')) return 115.8605;
  if (lower.contains('adelaide')) return 138.6007;
  if (lower.contains('gold coast')) return 153.4000;
  if (lower.contains('canberra')) return 149.1300;
  if (lower.contains('hobart')) return 147.3272;
  if (lower.contains('darwin')) return 130.8456;
  if (lower.contains('newcastle')) return 151.7817;
  if (lower.contains('wollongong')) return 150.8931;
  if (lower.contains('geelong')) return 144.3618;
  if (lower.contains('townsville')) return 146.8169;
  if (lower.contains('cairns')) return 145.7781;
  if (lower.contains('toowoomba')) return 151.9507;
  return null;
}
