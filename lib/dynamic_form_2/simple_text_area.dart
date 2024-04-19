import 'package:dyanamic_form_with_json/dynamic_form_2/dynamic_field_model.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleTextArea extends StatefulWidget {
  const SimpleTextArea({
    super.key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
  });

  final Fields item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;

  @override
  _SimpleText createState() => _SimpleText();
}

class _SimpleText extends State<SimpleTextArea> {
  Fields? item;

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
    if (labelHidden(item)) {
      label = Text(
        item!.label.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.comment, size: 30), // Prefix icon
            SizedBox(height: 8), // Space between icon and text field
            Expanded(child: LayoutBuilder(builder: (context,constraint){
              return TextFormField(
                controller: null,
                initialValue: item?.value,
                decoration: item?.decoration ??
                    widget.decorations[item?.key] ??
                    InputDecoration(
                      labelText: item?.helpText ?? "",
                      hintText: item?.placeholder ?? "",
                      filled: true,
                      // Fill color
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black87, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black87, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                keyboardType: TextInputType.multiline,
                maxLines: null, // Makes it grow vertically
                validator: (value) {
                  if (widget.validations.containsKey(item?.key)) {
                    return widget.validations[item?.key](item, value);
                  }
                  /* if (item.containsKey('validator')) {
                  if (item['validator'] != null) {
                    if (item['validator'] is Function) {
                      return item['validator'](item, value);
                    }
                  }
                }*/
                  if (item?.type == "Email") {
                    return Utils.validateEmail(item?.pattern, value!);
                  }

                  // if (item.containsKey('required')) {
                  if (item?.required == true ||
                      item?.required == 'True' ||
                      item?.required == 'true') {
                    return isRequired(item as Fields, value);
                  }
                  // }
                  return null;
                },
              );
            })),
            const Icon(Icons.comment, size: 30), // Prefix icon
            const SizedBox(height: 8),
          ],
        ),
        ],
      ),
    );
  }

  bool labelHidden(item) {
    if ((item as Fields).hiddenLabel != null) {
      if (item.hiddenLabel is bool) {
        return !item.hiddenLabel!;
      }
    } else {
      return true;
    }
    return false;
  }
}
