import 'dart:math';

import 'package:asp/asp.dart';

import 'config_states.dart';

const _kEmptyDraws = <int>[];

// atom
final configState = atom<ConfigState>(
  const ConfigInactive(),
  key: 'configState',
);

final drawState = atom<List<int>>(_kEmptyDraws, key: 'drawState');

// actions
final configReset = atomAction((set) {
  final slots = configState.state.slots;
  set(configState, ConfigInactive(slots));
  set(drawState, _kEmptyDraws);
}, key: 'configReset');

final configSet = atomAction1<int>((set, slots) {
  set(configState, ConfigActive(slots));
  set(drawState, _kEmptyDraws);
}, key: 'configSet');

final drawNext = atomAction((set) {
  final slots = configState.state.slots;
  final draws = drawState.state;
  if (draws.length >= slots) return;

  var next = 0;
  do {
    next = Random.secure().nextInt(slots) + 1;
  } while (draws.contains(next));

  set(drawState, [...draws, next]);
}, key: 'drawNext');

// computed
final drawsSelector = selector<List<int>>((get) {
  return get(drawState).reversed.toList();
});

final drawsCountSelector = selector<int>((get) {
  return get(drawsSelector).length;
});

final drawLastSelector = selector<int?>((get) {
  return get(drawsSelector).firstOrNull;
});

final drawingSelector = selector<bool>((get) {
  final config = get(configState);
  return config is ConfigActive;
});

final canDrawSelector = selector<bool>((get) {
  final config = get(configState);
  final drawing = get(drawingSelector);
  final draws = get(drawsSelector);

  return drawing && draws.length < config.slots;
});

final hasDrawSelector = selector<bool>((get) {
  final drawing = get(drawingSelector);
  final drawLast = get(drawLastSelector);

  return drawing && drawLast != null;
});
