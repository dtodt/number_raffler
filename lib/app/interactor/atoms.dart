import 'package:asp/asp.dart';
import 'package:value_selectable/value_selectable.dart';

import 'config_states.dart';

// atom
final configState = Atom<ConfigState>(
  const ConfigInactive(),
  key: 'configState',
);

final drawState = Atom<List<int>>([], key: 'drawState');

// actions
final configReset = Atom.action(key: 'configReset');
final configSet = Atom<int>(0, key: 'configSet');

final drawNext = Atom.action(key: 'drawNext');

// computed
final drawsSelector = ValueSelector<List<int>>((get) {
  return get(drawState).reversed.toList();
});

final drawsCountSelector = ValueSelector<int>((get) {
  return get(drawsSelector).length;
});

final drawLastSelector = ValueSelector<int?>((get) {
  return get(drawsSelector).firstOrNull;
});

final drawingSelector = ValueSelector<bool>((get) {
  final config = get(configState);
  return config is ConfigActive;
});

final canDrawSelector = ValueSelector<bool>((get) {
  final config = get(configState);
  final drawing = get(drawingSelector);
  final draws = get(drawsSelector);

  return drawing && draws.length < config.slots;
});

final hasDrawSelector = ValueSelector<bool>((get) {
  final drawing = get(drawingSelector);
  final drawLast = get(drawLastSelector);

  return drawing && drawLast != null;
});
