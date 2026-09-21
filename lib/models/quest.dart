enum QuestType { observe, count, reflect, act }

class Quest {
  final String id;
  final String poiId;
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
