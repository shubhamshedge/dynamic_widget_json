import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:flutter/material.dart';

import 'app_constant.dart';
import 'dynamic_field_model.dart';

class SimpleRadioButton extends StatefulWidget {
  const SimpleRadioButton({
    Key? key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages,
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
  }) : super(key: key);
  final dynamic item;
  final Function onChange;
  final int position;
  final Map? errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;

  @override
  _SimpleRadios createState() => _SimpleRadios();
}

class _SimpleRadios extends State<SimpleRadioButton> {
  late Fields item;
  late int radioValue;

  String? isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages?[item.key] ?? 'Please enter some text';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    Widget? title;
    List<Widget> radios = [];

    if (Utils.labelHidden(item)) {
      title = Text(item.label.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));
    }
    radioValue = item.value;
    for (var i = 0; i < item.items!.length; i++) {
      radios.add(
        Row(
          children: <Widget>[
            Expanded(child: Text(item.items![i].label.toString())),
            Radio<dynamic>(
                value: item.items![i].value,
                groupValue: radioValue,
                onChanged: (dynamic value) {
                  setState(() {
                    radioValue = value;
                    item.value = value;
                    widget.errorMessages?.clear();
                    widget.onChange(widget.position, value);
                  });
                })
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title ?? const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black87, // Border color
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(5), // Border radius
            ),
            child: ListView.builder(
              itemCount: radios.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return radios[index];
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.errorMessages!.isNotEmpty &&
              widget.errorMessages!.containsKey(AppConstant.radioButton))
            Text(widget.errorMessages![AppConstant.radioButton],
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
