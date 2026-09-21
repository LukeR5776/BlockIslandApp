import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:block_island/state/app_state.dart';
import 'package:block_island/models/poi.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggleQuest adds and removes quest from set', () async {
    final state = AppState();
    await state.load();

    expect(state.isQuestComplete('quest-1'), false);
    expect(state.questsCompleted, 0);

    state.toggleQuest('quest-1');
    expect(state.isQuestComplete('quest-1'), true);
    expect(state.questsCompleted, 1);

    state.toggleQuest('quest-1');
    expect(state.isQuestComplete('quest-1'), false);
    expect(state.questsCompleted, 0);
  });

  test('persistence round-trip saves and loads state', () async {
    SharedPreferences.setMockInitialValues({});

    final state1 = AppState();
    await state1.load();
    state1.toggleQuest('quest-1');
    state1.toggleQuest('quest-2');
    state1.markModuleRead('module-1');
    state1.toggleAction('action-1');

    await Future.delayed(const Duration(milliseconds: 100));

    final state2 = AppState();
    await state2.load();

    expect(state2.isQuestComplete('quest-1'), true);
    expect(state2.isQuestComplete('quest-2'), true);
    expect(state2.isModuleRead('module-1'), true);
    expect(state2.isActionCommitted('action-1'), true);
  });

  test('progress counts calculate correctly', () async {
    final state = AppState();
    await state.load();

    const testPois = [
      Poi(
        id: 'poi-1',
        name: 'Test POI 1',
        shortDescription: 'Short',
        description: 'Long description',
        category: PoiCategory.shore,
        mapX: 0.5,
        mapY: 0.5,
        imageAsset: 'test.jpg',
        questIds: ['quest-1', 'quest-2'],
        moduleIds: [],
      ),
      Poi(
        id: 'poi-2',
        name: 'Test POI 2',
        shortDescription: 'Short',
        description: 'Long description',
        category: PoiCategory.trail,
        mapX: 0.3,
        mapY: 0.3,
        imageAsset: 'test.jpg',
        questIds: ['quest-3'],
        moduleIds: [],
      ),
      Poi(
        id: 'poi-3',
        name: 'Test POI 3',
        shortDescription: 'Short',
        description: 'Long description',
        category: PoiCategory.historic,
        mapX: 0.7,
        mapY: 0.7,
        imageAsset: 'test.jpg',
        questIds: ['quest-4'],
        moduleIds: [],
      ),
    ];

    expect(state.questsCompleted, 0);
    expect(state.poisVisited(testPois), 0);

    state.toggleQuest('quest-1');
    expect(state.questsCompleted, 1);
    expect(state.poisVisited(testPois), 1);

    state.toggleQuest('quest-2');
    expect(state.questsCompleted, 2);
    expect(state.poisVisited(testPois), 1);

    state.toggleQuest('quest-3');
    expect(state.questsCompleted, 3);
    expect(state.poisVisited(testPois), 2);
  });
}
