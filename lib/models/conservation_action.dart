enum ActionKind { habit, event, volunteer, support }

class ConservationAction {
  final String id;
  final String title;
  final String description;
  final ActionKind kind;
  final List<String> steps;
  final String? url;

  const ConservationAction({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.steps,
    this.url,
  });
}
