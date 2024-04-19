import 'package:dyanamic_form_with_json/dynamic_form_2/dynamic_field_model.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:flutter/material.dart';

class SimpleSelect extends StatefulWidget {
  const SimpleSelect({
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
  _SimpleSelect createState() => _SimpleSelect();
}

class _SimpleSelect extends State<SimpleSelect> {
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
  }

  @override
  Widget build(BuildContext context) {
    Widget label = const SizedBox.shrink();
    if (Utils.labelHidden(item)) {
      label = Text(item.label.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label,
          const SizedBox(
            height: 10,
          ),
          InputDecorator(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 10, 20, 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: "verdana_regular",
                ),
                hint: const Text(
                  "Select Bank",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                  ),
                ),
                items: item.items!.map<DropdownMenuItem<String>>((Items data) {
                  return DropdownMenuItem<String>(
                    value: data.value,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Text(
                        data.label.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
                isExpanded: true,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    item.value = newValue;
                    widget.onChange(widget.position, newValue);
                  });
                },
                value: item.value,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
