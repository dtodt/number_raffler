import 'package:auto_injector/auto_injector.dart';

final appModule = AutoInjector(
  tag: 'AppModule',
);

void registerInstances() {
  appModule.commit();
}
