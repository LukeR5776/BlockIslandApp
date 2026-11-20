import 'package:flutter_test/flutter_test.dart';
import 'package:block_island/models/poi.dart';
import 'package:block_island/data/pois.dart';
import 'package:block_island/data/actions.dart';
import 'package:block_island/data/modules.dart';
import 'package:block_island/data/content_index.dart';

void main() {
  group('POI ID uniqueness', () {
    test('all POI IDs are unique', () {
      final ids = kPois.map((poi) => poi.id).toList();
      final uniqueIds = ids.toSet();
      expect(
        ids.length,
        uniqueIds.length,
        reason:
            'Duplicate POI IDs found: ${ids.where((id) => ids.where((x) => x == id).length > 1).toSet()}',
      );
    });
  });

  group('POI ID format', () {
    test('all POI IDs are lowercase kebab-case', () {
      final invalidIds = <String>[];
      for (final poi in kPois) {
        final id = poi.id;
        // Check for lowercase, hyphens, and no spaces or underscores
        if (!RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(id)) {
          invalidIds.add(id);
        }
      }
      expect(
        invalidIds,
        isEmpty,
        reason:
            'POI IDs must be lowercase kebab-case (no spaces, underscores, or uppercase): $invalidIds',
      );
    });
  });

  group('POI short description length', () {
    test('all short descriptions are 60 characters or fewer', () {
      final tooLong = <String, int>{};
      for (final poi in kPois) {
        if (poi.shortDescription.length > 60) {
          tooLong[poi.id] = poi.shortDescription.length;
        }
      }
      expect(
        tooLong,
        isEmpty,
        reason:
            'Short descriptions exceed 60 chars: ${tooLong.entries.map((e) => '${e.key} (${e.value} chars)').join(', ')}',
      );
    });
  });

  group('POI required fields', () {
    test('no POI has empty string fields', () {
      final emptyFields = <String, List<String>>{};
      for (final poi in kPois) {
        final empty = <String>[];
        if (poi.id.isEmpty) empty.add('id');
        if (poi.name.isEmpty) empty.add('name');
        if (poi.shortDescription.isEmpty) empty.add('shortDescription');
        if (poi.description.isEmpty) empty.add('description');
        if (poi.imageAsset.isEmpty) empty.add('imageAsset');
        if (empty.isNotEmpty) {
          emptyFields[poi.id.isEmpty ? '<empty-id>' : poi.id] = empty;
        }
      }
      expect(
        emptyFields,
        isEmpty,
        reason:
            'POIs with empty fields: ${emptyFields.entries.map((e) => '${e.key}: ${e.value.join(', ')}').join('; ')}',
      );
    });
  });

  group('POI coordinates', () {
    test(
      'all lat values are within [41.11, 41.27] and lng within [-71.65, -71.51]',
      () {
        final outOfBounds = <String, String>{};
        for (final poi in kPois) {
          final issues = <String>[];
          if (poi.lat < 41.11 || poi.lat > 41.27) {
            issues.add('lat=${poi.lat}');
          }
          if (poi.lng < -71.65 || poi.lng > -71.51) {
            issues.add('lng=${poi.lng}');
          }
          if (issues.isNotEmpty) {
            outOfBounds[poi.id] = issues.join(', ');
          }
        }
        expect(
          outOfBounds,
          isEmpty,
          reason:
              'POIs with out-of-bounds coordinates: ${outOfBounds.entries.map((e) => '${e.key} (${e.value})').join('; ')}',
        );
      },
    );
  });

  group('POI image assets', () {
    test('all imageAsset paths start with assets/images/ and end with .jpg', () {
      final invalidPaths = <String, String>{};
      for (final poi in kPois) {
        final path = poi.imageAsset;
        if (!path.startsWith('assets/images/') || !path.endsWith('.jpg')) {
          invalidPaths[poi.id] = path;
        }
      }
      expect(
        invalidPaths,
        isEmpty,
        reason:
            'Invalid imageAsset paths: ${invalidPaths.entries.map((e) => '${e.key}: ${e.value}').join('; ')}',
      );
    });
  });

  group('POI categories', () {
    test('all POI categories are valid PoiCategory values', () {
      final invalidCategories = <String, PoiCategory>{};
      for (final poi in kPois) {
        if (!PoiCategory.values.contains(poi.category)) {
          invalidCategories[poi.id] = poi.category;
        }
      }
      expect(
        invalidCategories,
        isEmpty,
        reason:
            'POIs with invalid categories: ${invalidCategories.entries.map((e) => '${e.key}: ${e.value}').join('; ')}',
      );
    });
  });

  group('POI relation lists', () {
    test('all questIds and moduleIds are empty for now', () {
      final nonEmpty = <String, String>{};
      for (final poi in kPois) {
        final issues = <String>[];
        if (poi.questIds.isNotEmpty) {
          issues.add('questIds: ${poi.questIds}');
        }
        if (poi.moduleIds.isNotEmpty) {
          issues.add('moduleIds: ${poi.moduleIds}');
        }
        if (issues.isNotEmpty) {
          nonEmpty[poi.id] = issues.join(', ');
        }
      }
      expect(
        nonEmpty,
        isEmpty,
        reason:
            'POIs with non-empty relation lists (should be empty until Week 3): ${nonEmpty.entries.map((e) => '${e.key}: ${e.value}').join('; ')}',
      );
    });
  });

  group('Conservation organizations', () {
    test('every curated organization ID resolves to a POI', () {
      final missing = conservationOrganizationIds
          .where((id) => !poiById.containsKey(id))
          .toList();
      expect(missing, isEmpty, reason: 'Unknown POI IDs: $missing');
    });
  });

  group('Conservation actions', () {
    test('all action IDs are unique', () {
      final ids = allActions.map((a) => a.id).toList();
      expect(ids.length, ids.toSet().length, reason: 'Duplicate action IDs');
    });

    test('every action url parses as an absolute URL', () {
      final invalid = <String, String>{};
      for (final action in allActions) {
        final url = action.url;
        if (url == null) continue;
        final uri = Uri.tryParse(url);
        if (uri == null || !uri.isAbsolute) invalid[action.id] = url;
      }
      expect(invalid, isEmpty, reason: 'Invalid action URLs: $invalid');
    });
  });

  group('Modules', () {
    test('all module IDs are unique', () {
      final ids = allModules.map((m) => m.id).toList();
      expect(ids.length, ids.toSet().length, reason: 'Duplicate module IDs');
    });

    test('every relatedPoiIds entry resolves to a POI', () {
      final broken = <String, List<String>>{};
      for (final module in allModules) {
        final missing = module.relatedPoiIds
            .where((id) => !poiById.containsKey(id))
            .toList();
        if (missing.isNotEmpty) broken[module.id] = missing;
      }
      expect(broken, isEmpty, reason: 'Unknown POI IDs: $broken');
    });

    test('every module has sections and at least one absolute source URL', () {
      final bad = <String>[];
      for (final module in allModules) {
        final sourcesOk =
            module.sources.isNotEmpty &&
            module.sources.every((s) => Uri.tryParse(s)?.isAbsolute ?? false);
        if (module.sections.isEmpty || !sourcesOk) bad.add(module.id);
      }
      expect(bad, isEmpty, reason: 'Modules missing sections or sources: $bad');
    });
  });
}
