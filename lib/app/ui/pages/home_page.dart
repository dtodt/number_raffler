import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import 'package:number_raffler/app/interactor/atoms.dart';
import 'package:number_raffler/app/interactor/config_states.dart';
import 'package:number_raffler/app/ui/widgets/config_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.viewInsetsOf(context).bottom;
    context.select(() => [draws, configState]);

    Widget? action;
    final config = configState.value;
    final active = config is ConfigActive;
    if (active && draws.length < config.slots) {
      action = FloatingActionButton(
        onPressed: drawNext.call,
        tooltip: 'Increment',
        child: const Icon(Icons.plus_one_rounded),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (keyboardSize == 0 && active && drawLast != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: SizedBox.square(
                    dimension: 75.0,
                    child: CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              '$drawLast',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.separated(
                itemBuilder: _item,
                itemCount: draws.length,
                padding: const EdgeInsets.all(16.0),
                physics: const BouncingScrollPhysics(),
                separatorBuilder: _separator,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConfigWidget(
                onReset: configReset.call,
                onSubmit: configSet.setValue,
                value: configState.value.slots,
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
      floatingActionButton: action,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget? _item(BuildContext context, int index) {
    if (index == 0) return const SizedBox();

    final item = draws.elementAt(index);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      title: Text('$item', textAlign: TextAlign.center),
      onTap: () {},
    );
  }

  Widget _separator(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = colorScheme.background;
    final center = colorScheme.tertiaryContainer;
    final centerText = colorScheme.onTertiary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            background,
            center,
            background,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.chevron_left_rounded, color: centerText),
        ),
      ),
    );
  }
}
