enum ActionKind { habit, event, volunteer, support }

extension ActionKindLabel on ActionKind {
  String get label => switch (this) {
    ActionKind.habit => 'Habits',
    ActionKind.event => 'Events',
    ActionKind.volunteer => 'Volunteer',
    ActionKind.support => 'Support',
  };
}

/// A Conservation tab item: a habit, event, or org to get involved with.
class ConservationAction {
  final String id;
  final String title;
  final String description;
  final ActionKind kind;
  final List<String> steps;
  final String? url; // external org link, opened via url_launcher

  const ConservationAction({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.steps,
    this.url,
  });
}
