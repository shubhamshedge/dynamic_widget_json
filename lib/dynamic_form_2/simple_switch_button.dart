import 'package:flutter/material.dart';

import 'dynamic_field_model.dart';

class SimpleSwitchButton extends StatefulWidget {
  const SimpleSwitchButton({
    Key? key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
  }) : super(key: key);
  final Fields item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;

  @override
  _SimpleSwitch createState() => _SimpleSwitch();
}

class _SimpleSwitch extends State<SimpleSwitchButton> {
  late Fields item;

  String? isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages[item.key] ?? 'Please enter some text';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
    item.value ??= false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Row(children: <Widget>[

            Expanded(
                child: Text(item.label.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0))),
            Switch(
              value: item.value ?? false,
              onChanged: (bool value) {
                setState(() {
                  item.value = value;
                  widget.onChange(widget.position, value);
                });
              },
            ),
          ]),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
