import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:flutter/material.dart';

import 'app_constant.dart';
import 'dynamic_field_model.dart';

class SimpleCheckbox extends StatefulWidget {
  const SimpleCheckbox({
    super.key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages,
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
  });

  final Fields item;
  final Function onChange;
  final int position;
  final Map? errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;

  @override
  _SimpleListCheckbox createState() => _SimpleListCheckbox();
}

class _SimpleListCheckbox extends State<SimpleCheckbox> {
  late Fields item;
  List<dynamic> selectItems = [];

  String? isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages![item['key']] ?? 'Please enter some text';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
    for (var i = 0; i < item.items!.length; i++) {
      if (item.items![i].value == true) {
        selectItems.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> checkboxes = [];
    Widget? titleWidget;
    if (Utils.labelHidden(item)) {
      titleWidget = Text(item.label.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));
    }

    for (var i = 0; i < item.items!.length; i++) {
      checkboxes.add(
        Row(
          children: <Widget>[
            Expanded(child: Text(item.items![i].label.toString())),
            Checkbox(
              value: item.items![i].value,
              onChanged: (bool? value) {
                setState(
                  () {
                    item.items![i].value = value;
                    if (value!) {
                      selectItems.add(i);
                    } else {
                      selectItems.remove(i);
                    }
                    widget.errorMessages?.clear();
                    widget.onChange(widget.position, selectItems);
                    //_handleChanged();
                  },
                );
              },
            ),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget ?? const SizedBox(),
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
              itemCount: checkboxes.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return checkboxes[index];
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.errorMessages!.isNotEmpty &&
              widget.errorMessages!.containsKey(AppConstant.str_checkbox))
            Text(widget.errorMessages![AppConstant.str_checkbox],style: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }
}
