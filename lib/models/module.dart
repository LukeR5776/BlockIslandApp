enum ModuleCategory { ecology, history, geology, community }

/// One reading section within a Module.
class ModuleSection {
  final String heading;
  final String body;
  final String? imageAsset;

  const ModuleSection({
    required this.heading,
    required this.body,
    this.imageAsset,
  });
}

/// An Education tab reading module.
class Module {
  final String id;
  final ModuleCategory category;
  final String title;
  final String summary;
  final List<ModuleSection> sections;
  final int readMinutes;
  final List<String> relatedPoiIds; // join key -> Poi.id
  final List<String> sources; // shown in About screen

  const Module({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.sections,
    required this.readMinutes,
    required this.relatedPoiIds,
    required this.sources,
  });
}
