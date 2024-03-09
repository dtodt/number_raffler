import 'dart:math';

import 'package:asp/asp.dart';

import 'atoms.dart';

class DrawReducer extends Reducer {
  DrawReducer() {
    on(() => [drawNext], () {
      final slots = configState.value.slots;
      if (draws.length >= slots) return;

      var next = 0;
      do {
        next = Random.secure().nextInt(slots) + 1;
      } while (draws.contains(next));

      drawState.setValue([...drawState.value, next]);
    });
  }
}
