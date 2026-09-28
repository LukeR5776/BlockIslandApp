import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poi.dart';

/// The app's entire mutable state. Persisted as three StringLists in
/// shared_preferences; writes are fire-and-forget after notifyListeners so
/// the UI never waits on disk.
class AppState extends ChangeNotifier {
  Set<String> _completedQuestIds = {};
  Set<String> _readModuleIds = {};
  Set<String> _committedActionIds = {};

  Set<String> get completedQuestIds => _completedQuestIds;
  Set<String> get readModuleIds => _readModuleIds;
  Set<String> get committedActionIds => _committedActionIds;

  bool isQuestComplete(String id) => _completedQuestIds.contains(id);
  bool isModuleRead(String id) => _readModuleIds.contains(id);
  bool isActionCommitted(String id) => _committedActionIds.contains(id);

  void toggleQuest(String id) {
    if (_completedQuestIds.contains(id)) {
      _completedQuestIds.remove(id);
    } else {
      _completedQuestIds.add(id);
    }
    notifyListeners();
    _persist();
  }

  void markModuleRead(String id) {
    _readModuleIds.add(id);
    notifyListeners();
    _persist();
  }

  void toggleAction(String id) {
    if (_committedActionIds.contains(id)) {
      _committedActionIds.remove(id);
    } else {
      _committedActionIds.add(id);
    }
    notifyListeners();
    _persist();
  }

  int get questsCompleted => _completedQuestIds.length;

  // A POI counts as visited when any one of its quests is complete.
  int poisVisited(List<Poi> allPois) {
    return allPois.where((poi) {
      return poi.questIds.any((questId) => _completedQuestIds.contains(questId));
    }).length;
  }

  /// Call once in main() before runApp — restores persisted sets from disk.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _completedQuestIds = (prefs.getStringList('completedQuestIds') ?? []).toSet();
    _readModuleIds = (prefs.getStringList('readModuleIds') ?? []).toSet();
    _committedActionIds = (prefs.getStringList('committedActionIds') ?? []).toSet();
    notifyListeners();
  }

  // Fired after every mutation; UI already updated via notifyListeners.
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedQuestIds', _completedQuestIds.toList());
    await prefs.setStringList('readModuleIds', _readModuleIds.toList());
    await prefs.setStringList('committedActionIds', _committedActionIds.toList());
  }
}
