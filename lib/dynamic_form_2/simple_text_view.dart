import 'package:dyanamic_form_with_json/dynamic_form_2/dynamic_field_model.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:flutter/material.dart';

import 'app_constant.dart';

class SimpleTextView extends StatefulWidget {
  const SimpleTextView(
      {super.key,
      this.controller,
      required this.item,
      required this.onChange,
      required this.position,
      this.errorMessages = const {},
      this.validations = const {},
      this.decorations = const {},
      this.keyboardTypes = const {},
      this.focusList});

  final Fields item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;
  final List<FocusNode?>? focusList;
  final TextEditingController? controller;

  @override
  _SimpleText createState() => _SimpleText();
}

class _SimpleText extends State<SimpleTextView> {
  Fields? item;
  final GlobalKey _textFieldKey = GlobalKey();
  Size? _textFieldSize;
  bool _sizeRetrieved = false;
  FocusNode? _emailFocusNode;
  FocusNode? _addressFocusNode;
  bool isFocusSet = false;

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
  void dispose() {
    _emailFocusNode?.dispose();
    _addressFocusNode?.dispose();
    super.dispose();
  }

  void getSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _textFieldKey.currentContext!.findRenderObject() as RenderBox;
      _textFieldSize = renderBox.size;
      print('TextField size: $_textFieldSize');
      setState(() {
        _sizeRetrieved = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_sizeRetrieved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getSize();
      });
    }

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
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            focusNode: getFocusElement(item!.type),
            key: _textFieldKey,
            controller: widget.controller,
            decoration: item?.decoration ??
                widget.decorations[item?.key] ??
                InputDecoration(
                  labelText: item?.helpText ?? "",
                  hintText: item?.placeholder ?? "",
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                  prefixIcon: item?.type == "TextArea"
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: _textFieldSize != null
                                  ? _textFieldSize!.height - 50
                                  : 0),
                          child: const Icon(Icons.person),
                        )
                      : const Icon(Icons.person),
                  suffixIcon: item?.type == "TextArea"
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: _textFieldSize != null
                                  ? _textFieldSize!.height - 50
                                  : 0),
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {},
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {},
                        ),
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
            maxLines: item?.type == "TextArea" ? item?.maxline : 1,
            onChanged: (String value) {
              item?.value = value;
              // widget.onChange(widget.position, value);
            },
            obscureText: item?.type == "Password" ? true : false,
            /*keyboardType: item?.keyboardType ??
                widget.keyboardTypes[item?.key] ??
                TextInputType.text,*/
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
              // if (item.containsKey('required')) {

              // updateFocusToLastField();

              if (item?.required == true ||
                  item?.required == 'True' ||
                  item?.required == 'true') {
                if (isRequired(item as Fields, value) != null) {
                  widget.focusList?.add(getFocusElement(item?.type));
                  updateFocusToLastField();
                }
                return isRequired(item as Fields, value);
              }
              if (item?.type == "Email") {
                if (Utils.validateEmail(item?.pattern, value!) != null) {
                  widget.focusList!.add(getFocusElement(item?.type));
                  updateFocusToLastField();
                }
                return Utils.validateEmail(item?.pattern, value!);
              }
              // }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
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

  FocusNode? getFocusElement(String? type) {
    switch (type) {
      case AppConstant.strInput:
      case AppConstant.strPassword:
      case AppConstant.strEmail:
      case AppConstant.strAddress:
      case AppConstant.strTextArea:
      case AppConstant.strTextInput:
        {
          if (_addressFocusNode != null) {
            return _addressFocusNode;
          } else {
            return _addressFocusNode = FocusNode();
          }
        }
      default:
        return _addressFocusNode = FocusNode();
    }
  }

  void updateFocusToLastField() {
    if (widget.focusList!.isNotEmpty) {
      widget.focusList![0]?.requestFocus();
    }
  }
}
