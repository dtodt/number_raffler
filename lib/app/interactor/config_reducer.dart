import 'package:asp/asp.dart';

import 'atoms.dart';
import 'config_states.dart';

class ConfigReducer extends Reducer {
  ConfigReducer() {
    on(() => [configReset], () {
      final slots = configState.value.slots;
      configState.setValue(ConfigInactive(slots));
      drawState.setValue([]);
    });
    on(() => [configSet], () {
      final slots = configSet.value;
      configState.setValue(ConfigActive(slots));
      drawState.setValue([]);
    });
  }
}
