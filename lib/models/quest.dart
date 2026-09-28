enum QuestType { observe, count, reflect, act }

/// A single "thing to do" tied to a POI, shown on PoiScreen.
class Quest {
  final String id;
  final String poiId; // join key -> Poi.id
  final String title;
  final String prompt;
  final QuestType type;

  const Quest({
    required this.id,
    required this.poiId,
    required this.title,
    required this.prompt,
    required this.type,
  });
}
