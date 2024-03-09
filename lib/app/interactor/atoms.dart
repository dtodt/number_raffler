import 'package:asp/asp.dart';

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
List<int> get draws => drawState.value.reversed.toList();
int? get drawLast => draws.elementAtOrNull(0);
