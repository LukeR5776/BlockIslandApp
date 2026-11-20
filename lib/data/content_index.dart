import '../models/conservation_action.dart';
import '../models/poi.dart';
import '../models/quest.dart';
import '../models/module.dart';
import 'actions.dart';
import 'pois.dart';
import 'quests.dart';
import 'modules.dart';

// ID lookup helpers, built once from the const data lists. Everything here
// is a derived index — the data files above are the source of truth.

final Map<String, Poi> poiById = {for (final poi in kPois) poi.id: poi};

final Map<PoiCategory, List<Poi>> poisByCategory = {
  for (final category in PoiCategory.values)
    category: kPois.where((poi) => poi.category == category).toList(),
};

final Map<String, List<Quest>> questsByPoiId = {
  for (final poi in kPois)
    poi.id: allQuests.where((q) => q.poiId == poi.id).toList(),
};

final Map<ModuleCategory, List<Module>> modulesByCategory = {
  for (final category in ModuleCategory.values)
    category: allModules.where((m) => m.category == category).toList(),
};

final Map<String, List<Module>> modulesByPoiId = {
  for (final poi in kPois)
    poi.id: allModules.where((m) => m.relatedPoiIds.contains(poi.id)).toList(),
};

final Map<ActionKind, List<ConservationAction>> actionsByKind = {
  for (final kind in ActionKind.values)
    kind: allActions.where((a) => a.kind == kind).toList(),
};

// Curated by ID rather than by category: the Historical Society is filed as
// historic on the map but belongs with the organizations here.
const conservationOrganizationIds = [
  'block-island-historical-society',
  'block-island-chamber-of-commerce',
  'island-free-library',
  'the-nature-conservancy',
  'block-island-maritime-institute',
];

final List<Poi> conservationOrganizations = [
  for (final id in conservationOrganizationIds)
    ?poiById[id],
];
