import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:number_raffler/app/interactor/atoms.dart';
import 'package:number_raffler/app/interactor/config_states.dart';

class ConfigWidget extends StatefulWidget {
  final VoidCallback onReset;
  final ValueChanged<int> onSubmit;
  final int value;

  const ConfigWidget({
    super.key,
    this.value = 0,
    required this.onReset,
    required this.onSubmit,
  });

  @override
  State<ConfigWidget> createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  final _formKey = GlobalKey<FormState>();

  var _autoValidate = AutovalidateMode.disabled;
  final _fieldFocus = FocusNode();
  var _formValid = true;

  late var _number = widget.value;

  @override
  Widget build(BuildContext context) {
    var initialValue = '';
    if (widget.value > 0) {
      initialValue = '${widget.value}';
    }

    final action = switch (configState.value) {
      ConfigActive() => widget.onReset,
      ConfigInactive() => _submit,
    };
    final actionLabel = switch (configState.value) {
      ConfigActive() => 'Reset configuration',
      ConfigInactive() => 'Configure',
    };

    var color = switch (configState.value) {
      ConfigActive() => Colors.green,
      ConfigInactive() => Colors.blue,
    };
    if (!_formValid) {
      color = Colors.red;
    }

    final colorReverse = switch (configState.value) {
      ConfigActive() => Colors.blue,
      ConfigInactive() => Colors.green,
    };

    final enabled = configState.value is ConfigInactive;

    final icon = switch (configState.value) {
      ConfigActive() => const Icon(Icons.replay_rounded),
      ConfigInactive() => const Icon(Icons.check),
    };

    return Form(
      autovalidateMode: _autoValidate,
      key: _formKey,
      child: Card(
        child: SizedBox(
          height: 120.0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox.square(dimension: 38.0),
                  const SizedBox(width: 16.0),
                  Semantics(
                    label: 'Number slots',
                    child: SizedBox(
                      width: 100.0,
                      child: TextFormField(
                        autofocus: true,
                        buildCounter: _buildCounter,
                        cursorColor: color.shade900,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color.shade900,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color.shade900,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color.shade900,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color.shade900,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color.shade900,
                            ),
                          ),
                          filled: true,
                          fillColor: color.shade100,
                          focusColor: color.shade900,
                        ),
                        enabled: enabled,
                        focusNode: _fieldFocus,
                        initialValue: initialValue,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            _number = int.tryParse(value) ?? 0;

                            if (AutovalidateMode.onUserInteraction ==
                                _autoValidate) {
                              _formValid = _number > 1;
                            }
                          });
                        },
                        onFieldSubmitted: _submit,
                        style: TextStyle(
                          color: color.shade900,
                        ),
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.send,
                        validator: (value) {
                          final numberValue = int.tryParse(value ?? '0') ?? 0;
                          if (numberValue > 1) {
                            return null;
                          }
                          return '';
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Semantics(
                      label: actionLabel,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: colorReverse.shade100,
                          foregroundColor: colorReverse.shade900,
                        ),
                        onPressed: action,
                        icon: icon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildCounter(BuildContext context,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength}) {
    return const SizedBox();
  }

  void _submit([String text = '']) {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) {
      setState(() {
        _autoValidate = AutovalidateMode.onUserInteraction;
        _formValid = false;
      });
      return _fieldFocus.requestFocus();
    }

    final toSubmit = int.tryParse(text) ?? _number;
    widget.onSubmit(toSubmit);
  }
}
