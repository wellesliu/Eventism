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

// Comprehensive geocoding lookup for Australian locations
// Returns (latitude, longitude) tuple
(double, double)? getCoordinates(String location) {
  final lower = location.toLowerCase();

  // Specific venues (most accurate)
  final venues = {
    // Sydney venues
    'whitlam leisure centre': (-33.9167, 150.9167), // Liverpool
    'sydney showground': (-33.8450, 151.0680),
    'icc sydney': (-33.8756, 151.1992),
    'hordern pavilion': (-33.8916, 151.2233),
    'moore park': (-33.8916, 151.2233),
    'royal randwick': (-33.9172, 151.2405),
    'luna park sydney': (-33.8476, 151.2095),
    'qudos bank arena': (-33.8467, 151.0628),
    'homebush': (-33.8594, 151.0644),
    'olympic park': (-33.8467, 151.0628),
    'rosehill gardens': (-33.8227, 151.0220),
    'parramatta park': (-33.8150, 151.0050),
    'castle hill showground': (-33.7316, 151.0064),
    'hawkesbury showground': (-33.6072, 150.7500),
    // Melbourne venues
    'melbourne showgrounds': (-37.7749, 144.9490),
    'melbourne convention': (-37.8265, 144.9535),
    'rod laver arena': (-37.8206, 144.9795),
    'melbourne arena': (-37.8206, 144.9795),
    'flemington racecourse': (-37.7877, 144.9118),
    'caulfield racecourse': (-37.8772, 145.0368),
    'sandown racecourse': (-37.9266, 145.1706),
    'moonee valley': (-37.7666, 144.9295),
    // Brisbane venues
    'brisbane showgrounds': (-27.4429, 153.0350),
    'rna showgrounds': (-27.4429, 153.0350),
    'brisbane convention': (-27.4747, 153.0266),
    'suncorp stadium': (-27.4648, 153.0095),
    // Adelaide venues
    'adelaide showground': (-34.9459, 138.5786),
    'wayville': (-34.9459, 138.5786),
    'adelaide convention': (-34.9204, 138.5937),
    // Perth venues
    'perth convention': (-31.9577, 115.8614),
    'claremont showground': (-31.9773, 115.7819),
    // Gold Coast venues
    'gold coast convention': (-28.0156, 153.4295),
    // Canberra venues
    'epic canberra': (-35.2472, 149.1806),
    'canberra convention': (-35.2847, 149.1273),
  };

  // Check specific venues first
  for (final entry in venues.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Sydney suburbs
  final sydneySuburbs = {
    'hurstville': (-33.9679, 151.1014),
    'parramatta': (-33.8150, 151.0010),
    'liverpool': (-33.9200, 150.9238),
    'bankstown': (-33.9178, 151.0331),
    'blacktown': (-33.7710, 150.9063),
    'penrith': (-33.7510, 150.6942),
    'campbelltown': (-34.0650, 150.8142),
    'sutherland': (-34.0317, 151.0577),
    'hornsby': (-33.7040, 151.0994),
    'chatswood': (-33.7969, 151.1803),
    'ryde': (-33.8151, 151.1021),
    'burwood': (-33.8768, 151.1045),
    'strathfield': (-33.8795, 151.0937),
    'auburn': (-33.8492, 151.0331),
    'fairfield': (-33.8722, 150.9561),
    'rockdale': (-33.9531, 151.1365),
    'kogarah': (-33.9649, 151.1316),
    'randwick': (-33.9172, 151.2405),
    'bondi': (-33.8910, 151.2728),
    'manly': (-33.7969, 151.2877),
    'cronulla': (-34.0556, 151.1519),
    'mascot': (-33.9290, 151.1875),
    'alexandria': (-33.9063, 151.1958),
    'redfern': (-33.8927, 151.2051),
    'surry hills': (-33.8833, 151.2111),
    'darlinghurst': (-33.8787, 151.2172),
    'newtown': (-33.8978, 151.1787),
    'marrickville': (-33.9106, 151.1547),
    'leichhardt': (-33.8820, 151.1582),
    'glebe': (-33.8788, 151.1868),
    'rozelle': (-33.8621, 151.1698),
    'balmain': (-33.8565, 151.1817),
    'drummoyne': (-33.8529, 151.1530),
    'five dock': (-33.8667, 151.1282),
    'concord': (-33.8590, 151.1037),
    'rhodes': (-33.8308, 151.0867),
    'meadowbank': (-33.8172, 151.0901),
    'ermington': (-33.8130, 151.0573),
    'castle hill': (-33.7316, 151.0064),
    'kellyville': (-33.7045, 150.9549),
    'baulkham hills': (-33.7623, 150.9934),
    'winston hills': (-33.7762, 150.9734),
    'westmead': (-33.8041, 150.9871),
    'seven hills': (-33.7745, 150.9360),
    'doonside': (-33.7654, 150.8736),
    'rooty hill': (-33.7711, 150.8444),
    'mt druitt': (-33.7671, 150.8203),
    'st marys': (-33.7621, 150.7739),
    'kingswood': (-33.7609, 150.7225),
    'emu plains': (-33.7496, 150.6599),
    'glenmore park': (-33.7852, 150.6676),
    'minto': (-34.0322, 150.8441),
    'ingleburn': (-33.9999, 150.8646),
    'leppington': (-33.9683, 150.8039),
    'oran park': (-34.0011, 150.7466),
    'camden': (-34.0544, 150.6957),
    'narellan': (-34.0434, 150.7285),
    'picton': (-34.1797, 150.6088),
    'wollondilly': (-34.2239, 150.5700),
    'hawkesbury': (-33.5867, 150.7500),
    'richmond': (-33.5989, 150.7514),
    'windsor': (-33.6104, 150.8127),
    'mount annan': (-34.0687, 150.7681),
    'miranda': (-34.0361, 151.1031),
    'caringbah': (-34.0456, 151.1214),
    'sylvania': (-34.0222, 151.1072),
    'jannali': (-34.0164, 151.0608),
    'engadine': (-34.0667, 151.0114),
    'heathcote': (-34.0858, 151.0097),
    'waterfall': (-34.1364, 150.9939),
    'helensburgh': (-34.1789, 150.9944),
    'stanwell park': (-34.2260, 150.9890),
  };

  for (final entry in sydneySuburbs.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Melbourne suburbs
  final melbourneSuburbs = {
    'footscray': (-37.8016, 144.8997),
    'maribyrnong': (-37.7725, 144.8894),
    'st kilda': (-37.8676, 144.9742),
    'south yarra': (-37.8383, 144.9913),
    'richmond': (-37.8192, 144.9985),
    'collingwood': (-37.8016, 144.9893),
    'fitzroy': (-37.7887, 144.9776),
    'carlton': (-37.7940, 144.9667),
    'brunswick': (-37.7666, 144.9602),
    'coburg': (-37.7423, 144.9643),
    'preston': (-37.7458, 145.0149),
    'northcote': (-37.7699, 145.0011),
    'heidelberg': (-37.7550, 145.0659),
    'box hill': (-37.8189, 145.1226),
    'doncaster': (-37.7880, 145.1261),
    'glen waverley': (-37.8792, 145.1649),
    'dandenong': (-37.9875, 145.2162),
    'frankston': (-38.1418, 145.1216),
    'moorabbin': (-37.9283, 145.0464),
    'chadstone': (-37.8867, 145.0844),
    'caulfield': (-37.8772, 145.0227),
    'brighton': (-37.9066, 145.0006),
    'sandringham': (-37.9489, 145.0050),
    'cheltenham': (-37.9692, 145.0500),
    'mentone': (-37.9836, 145.0639),
    'mordialloc': (-38.0067, 145.0861),
    'essendon': (-37.7524, 144.9167),
    'moonee ponds': (-37.7666, 144.9295),
    'ascot vale': (-37.7783, 144.9252),
    'kensington': (-37.7933, 144.9283),
    'south melbourne': (-37.8316, 144.9566),
    'port melbourne': (-37.8386, 144.9359),
    'docklands': (-37.8146, 144.9426),
    'williamstown': (-37.8594, 144.8856),
    'altona': (-37.8683, 144.8306),
    'werribee': (-37.9003, 144.6608),
    'hoppers crossing': (-37.8836, 144.6997),
    'point cook': (-37.9167, 144.7472),
    'tarneit': (-37.8378, 144.6944),
    'melton': (-37.6833, 144.5833),
    'sunbury': (-37.5776, 144.7264),
    'craigieburn': (-37.6000, 144.9500),
    'epping': (-37.6500, 145.0333),
    'south morang': (-37.6553, 145.0922),
    'mill park': (-37.6647, 145.0633),
    'bundoora': (-37.6996, 145.0606),
    'greensborough': (-37.7047, 145.1036),
    'eltham': (-37.7144, 145.1475),
    'ringwood': (-37.8142, 145.2292),
    'croydon': (-37.7948, 145.2817),
    'lilydale': (-37.7569, 145.3528),
    'belgrave': (-37.9092, 145.3547),
    'ferntree gully': (-37.8792, 145.2875),
    'rowville': (-37.9197, 145.2339),
    'narre warren': (-38.0333, 145.3000),
    'berwick': (-38.0333, 145.3500),
    'pakenham': (-38.0714, 145.4867),
    'cranbourne': (-38.1000, 145.2833),
  };

  for (final entry in melbourneSuburbs.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Brisbane suburbs
  final brisbaneSuburbs = {
    'fortitude valley': (-27.4569, 153.0350),
    'south brisbane': (-27.4800, 153.0200),
    'west end': (-27.4833, 153.0100),
    'woolloongabba': (-27.4900, 153.0350),
    'kangaroo point': (-27.4781, 153.0350),
    'new farm': (-27.4633, 153.0517),
    'teneriffe': (-27.4550, 153.0467),
    'newstead': (-27.4467, 153.0433),
    'bowen hills': (-27.4429, 153.0350),
    'windsor': (-27.4333, 153.0300),
    'wilston': (-27.4283, 153.0183),
    'ashgrove': (-27.4383, 152.9933),
    'paddington': (-27.4600, 152.9983),
    'red hill': (-27.4650, 153.0017),
    'kelvin grove': (-27.4483, 153.0117),
    'herston': (-27.4467, 153.0233),
    'spring hill': (-27.4617, 153.0233),
    'milton': (-27.4700, 153.0017),
    'toowong': (-27.4817, 152.9883),
    'indooroopilly': (-27.5017, 152.9750),
    'st lucia': (-27.4983, 153.0017),
    'taringa': (-27.4917, 152.9833),
    'graceville': (-27.5167, 152.9817),
    'sherwood': (-27.5267, 152.9817),
    'corinda': (-27.5417, 152.9850),
    'oxley': (-27.5583, 152.9833),
    'inala': (-27.5917, 152.9717),
    'richlands': (-27.5750, 152.9517),
    'darra': (-27.5500, 152.9433),
    'sumner': (-27.5583, 152.9217),
    'wacol': (-27.5750, 152.9117),
    'ipswich': (-27.6167, 152.7667),
    'springfield': (-27.6572, 152.9097),
    'forest lake': (-27.6217, 152.9617),
    'browns plains': (-27.6583, 153.0500),
    'logan': (-27.6389, 153.1094),
    'woodridge': (-27.6333, 153.1083),
    'beenleigh': (-27.7167, 153.2000),
    'redland bay': (-27.6167, 153.3000),
    'capalaba': (-27.5333, 153.1917),
    'cleveland': (-27.5333, 153.2667),
    'wynnum': (-27.4567, 153.1617),
    'manly': (-27.4583, 153.1883),
    'sandgate': (-27.3200, 153.0667),
    'redcliffe': (-27.2333, 153.1167),
    'petrie': (-27.2667, 152.9833),
    'strathpine': (-27.3000, 152.9833),
    'albany creek': (-27.3500, 152.9667),
    'everton park': (-27.4050, 152.9833),
    'mitchelton': (-27.4167, 152.9667),
    'chermside': (-27.3850, 153.0300),
    'aspley': (-27.3633, 153.0167),
    'zillmere': (-27.3583, 153.0417),
    'geebung': (-27.3733, 153.0433),
    'nundah': (-27.4000, 153.0567),
    'virginia': (-27.3850, 153.0617),
    'northgate': (-27.3900, 153.0700),
    'banyo': (-27.3733, 153.0833),
    'nudgee': (-27.3667, 153.1000),
    'eagle farm': (-27.4367, 153.0817),
    'hamilton': (-27.4383, 153.0650),
    'ascot': (-27.4283, 153.0617),
    'clayfield': (-27.4167, 153.0550),
    'hendra': (-27.4200, 153.0717),
    'cannon hill': (-27.4700, 153.0950),
    'morningside': (-27.4617, 153.0783),
    'coorparoo': (-27.4900, 153.0567),
    'camp hill': (-27.4983, 153.0683),
    'carindale': (-27.5017, 153.1050),
    'mount gravatt': (-27.5333, 153.0833),
    'sunnybank': (-27.5783, 153.0583),
    'eight mile plains': (-27.5783, 153.0917),
  };

  for (final entry in brisbaneSuburbs.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Other Queensland locations
  final queenslandOther = {
    'toowoomba': (-27.5598, 151.9507),
    'glenvale': (-27.5550, 151.8883),
    'ipswich': (-27.6167, 152.7667),
    'sunshine coast': (-26.6500, 153.0667),
    'maroochydore': (-26.6583, 153.1000),
    'caloundra': (-26.8000, 153.1333),
    'noosa': (-26.3833, 153.0833),
    'hervey bay': (-25.2883, 152.8406),
    'bundaberg': (-24.8661, 152.3489),
    'rockhampton': (-23.3792, 150.5100),
    'mackay': (-21.1439, 149.1869),
    'cairns': (-16.9186, 145.7781),
    'townsville': (-19.2590, 146.8169),
  };

  for (final entry in queenslandOther.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Adelaide suburbs
  final adelaideSuburbs = {
    'wayville': (-34.9459, 138.5786),
    'unley': (-34.9500, 138.5833),
    'norwood': (-34.9167, 138.6333),
    'glenelg': (-34.9833, 138.5167),
    'henley beach': (-34.9167, 138.5000),
    'port adelaide': (-34.8333, 138.5000),
    'salisbury': (-34.7667, 138.6500),
    'elizabeth': (-34.7167, 138.6667),
    'tea tree gully': (-34.8333, 138.7333),
    'modbury': (-34.8333, 138.6833),
    'campbelltown': (-34.8667, 138.6667),
    'paradise': (-34.8833, 138.6667),
    'magill': (-34.9167, 138.6667),
    'burnside': (-34.9333, 138.6333),
    'fullarton': (-34.9500, 138.6333),
    'mitcham': (-34.9667, 138.6167),
    'colonel light gardens': (-34.9833, 138.5833),
    'pasadena': (-34.9833, 138.6000),
    'marion': (-35.0000, 138.5500),
    'morphett vale': (-35.1333, 138.5167),
    'christie downs': (-35.1167, 138.4833),
    'noarlunga': (-35.1500, 138.5000),
    'mount barker': (-35.0667, 138.8667),
  };

  for (final entry in adelaideSuburbs.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Perth suburbs
  final perthSuburbs = {
    'fremantle': (-32.0569, 115.7439),
    'joondalup': (-31.7450, 115.7661),
    'rockingham': (-32.2833, 115.7333),
    'mandurah': (-32.5289, 115.7219),
    'armadale': (-32.1500, 116.0167),
    'midland': (-31.8833, 116.0167),
    'cannington': (-32.0167, 115.9333),
    'morley': (-31.9000, 115.9167),
    'scarborough': (-31.8833, 115.7667),
    'subiaco': (-31.9500, 115.8333),
    'claremont': (-31.9773, 115.7819),
    'cottesloe': (-31.9992, 115.7553),
    'nedlands': (-31.9833, 115.8000),
    'perth city': (-31.9505, 115.8605),
    'northbridge': (-31.9456, 115.8572),
    'leederville': (-31.9333, 115.8500),
    'mount lawley': (-31.9333, 115.8833),
    'inglewood': (-31.9167, 115.8833),
    'bayswater': (-31.9167, 115.9167),
    'belmont': (-31.9500, 115.9333),
    'victoria park': (-31.9750, 115.8917),
    'south perth': (-31.9667, 115.8667),
    'como': (-31.9917, 115.8667),
    'applecross': (-32.0167, 115.8333),
    'melville': (-32.0500, 115.8000),
    'willetton': (-32.0500, 115.8667),
    'canning vale': (-32.0583, 115.9167),
    'thornlie': (-32.0583, 115.9583),
    'gosnells': (-32.0833, 115.9833),
    'kalamunda': (-31.9667, 116.0500),
    'mundaring': (-31.9000, 116.1667),
    'ellenbrook': (-31.7667, 115.9667),
    'wanneroo': (-31.7500, 115.8000),
    'balcatta': (-31.8667, 115.8167),
    'stirling': (-31.8833, 115.8167),
    'osborne park': (-31.8917, 115.8083),
    'innaloo': (-31.8917, 115.7917),
    'karrinyup': (-31.8667, 115.7750),
    'hillarys': (-31.8167, 115.7333),
    'sorrento': (-31.8333, 115.7500),
  };

  for (final entry in perthSuburbs.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  // Fallback to city-level coordinates
  final cities = {
    'new south wales': (-33.8688, 151.2093),
    'sydney': (-33.8688, 151.2093),
    'victoria': (-37.8136, 144.9631),
    'melbourne': (-37.8136, 144.9631),
    'queensland': (-27.4698, 153.0251),
    'brisbane': (-27.4698, 153.0251),
    'western australia': (-31.9505, 115.8605),
    'perth': (-31.9505, 115.8605),
    'south australia': (-34.9285, 138.6007),
    'adelaide': (-34.9285, 138.6007),
    'gold coast': (-28.0167, 153.4000),
    'canberra': (-35.2809, 149.1300),
    'act': (-35.2809, 149.1300),
    'hobart': (-42.8821, 147.3272),
    'tasmania': (-42.8821, 147.3272),
    'darwin': (-12.4634, 130.8456),
    'northern territory': (-12.4634, 130.8456),
    'newcastle': (-32.9283, 151.7817),
    'wollongong': (-34.4248, 150.8931),
    'geelong': (-38.1499, 144.3618),
  };

  for (final entry in cities.entries) {
    if (lower.contains(entry.key)) {
      return entry.value;
    }
  }

  return null;
}

double? getLatitude(String location) {
  final coords = getCoordinates(location);
  return coords?.$1;
}

double? getLongitude(String location) {
  final coords = getCoordinates(location);
  return coords?.$2;
}
