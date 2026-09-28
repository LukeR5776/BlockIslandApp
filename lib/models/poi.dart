enum PoiCategory { shore, trail, historic, landmark, organization }

/// A point of interest on the Exploration map.
class Poi {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final PoiCategory category;
  final double lat;
  final double lng;
  final String imageAsset;
  final String? visitorNote; // practical caution, e.g. steep stairs
  final List<String> questIds; // join key -> Quest.poiId
  final List<String> moduleIds; // join key -> Module.relatedPoiIds

  const Poi({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.category,
    required this.lat,
    required this.lng,
    required this.imageAsset,
    this.visitorNote,
    required this.questIds,
    required this.moduleIds,
  });
}
