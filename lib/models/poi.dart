enum PoiCategory { shore, trail, historic, landmark, organization }

class Poi {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final PoiCategory category;
  final double mapX;
  final double mapY;
  final String imageAsset;
  final String? visitorNote;
  final List<String> questIds;
  final List<String> moduleIds;

  const Poi({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.category,
    required this.mapX,
    required this.mapY,
    required this.imageAsset,
    this.visitorNote,
    required this.questIds,
    required this.moduleIds,
  });
}
