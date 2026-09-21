import '../models/poi.dart';
import '../models/quest.dart';
import '../models/module.dart';
import 'pois.dart';
import 'quests.dart';
import 'modules.dart';

final Map<String, Poi> poiById = {
  for (final poi in kPois) poi.id: poi,
};

final Map<PoiCategory, List<Poi>> poisByCategory = {
  for (final category in PoiCategory.values)
    category: kPois.where((poi) => poi.category == category).toList(),
};

final Map<String, List<Quest>> questsByPoiId = {
  for (final poi in kPois)
    poi.id: allQuests.where((q) => q.poiId == poi.id).toList(),
};

final Map<String, List<Module>> modulesByPoiId = {
  for (final poi in kPois)
    poi.id: allModules.where((m) => m.relatedPoiIds.contains(poi.id)).toList(),
};
