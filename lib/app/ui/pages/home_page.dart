import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import 'package:number_raffler/app/interactor/config_atoms.dart';
import 'package:number_raffler/app/ui/widgets/config_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HookStateMixin {
  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.viewInsetsOf(context).bottom;

    final canDraw = useAtomState(canDrawSelector);
    final hasDraw = useAtomState(hasDrawSelector);
    final lastDraw = useAtomState(drawLastSelector);
    final totalDraws = useAtomState(drawsCountSelector);

    Widget? action;
    if (canDraw) {
      action = Semantics(
        label: 'Generate number',
        child: FloatingActionButton(
          onPressed: drawNext.call,
          tooltip: 'Increment',
          child: const Icon(Icons.plus_one_rounded),
        ),
      );
    }

    return Semantics(
      label: 'Home page',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (keyboardSize == 0 && hasDraw)
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
                                '$lastDraw',
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
                  itemCount: totalDraws,
                  padding: const EdgeInsets.all(16.0),
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: _separator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConfigWidget(
                  onReset: configReset.call,
                  onSubmit: configSet.call,
                  value: configState.state.slots,
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
        floatingActionButton: action,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget? _item(BuildContext context, int index) {
    if (index == 0) return const SizedBox();

    final draws = useAtomState(drawsSelector);
    final item = draws.elementAt(index);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      title: Text('$item', textAlign: TextAlign.center),
      onTap: () {},
    );
  }

  Widget _separator(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = colorScheme.surface;
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
