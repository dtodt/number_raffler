sealed class ConfigState {
  final int slots;

  const ConfigState(this.slots);
}

final class ConfigInactive extends ConfigState {
  const ConfigInactive([super.slots = 0]);
}

final class ConfigActive extends ConfigState {
  const ConfigActive(super.slots);
}
