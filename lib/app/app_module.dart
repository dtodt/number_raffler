import 'package:auto_injector/auto_injector.dart';

import 'interactor/config_reducer.dart';
import 'interactor/draw_reducer.dart';

final appModule = AutoInjector(
  tag: 'AppModule',
);

void registerInstances() {
  appModule.addSingleton(ConfigReducer.new);
  appModule.addSingleton(DrawReducer.new);
  appModule.commit();
}
