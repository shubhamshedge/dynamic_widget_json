import 'dart:io';
import 'dart:typed_data';

import 'package:dyanamic_form_with_json/dynamic_form_2/app_constant.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/dynamic_field_model.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/responsive.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/simple_checkbox.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/simple_date.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/simple_radio_button.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/simple_select.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/simple_switch_button.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/simple_text_view.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormElement extends StatefulWidget {
  const FormElement({
    super.key,
    this.form,
    required this.onChanged,
    this.padding,
    this.formMap,
    this.autovalidateMode,
    this.errorMessages,
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
    this.buttonSave,
    this.actionSave,
  });

  final Map? errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;
  final DynamicFieldModel? form;
  final Map? formMap;
  final double? padding;
  final Widget? buttonSave;
  final Function? actionSave;
  final ValueChanged<dynamic> onChanged;
  final AutovalidateMode? autovalidateMode;

  @override
  _CoreFormState createState() => _CoreFormState(form!);
}

class _CoreFormState extends State<FormElement> {
  final DynamicFieldModel formGeneral;
  Map<String, String>? radioErrorText = {};
  late int radioValue;
  var completeText = "";

  //pick file variable
  PlatformFile? _fileName;
  FilePickerResult? _paths;
  String? _extension;
  final bool _lockParentWindow = false;
  final bool _multiPick = false;
  final FileType _pickingType = FileType.any;

  // Create a map to associate each TextField with its own controller
  final Map<int, TextEditingController> _controllers = {};

  _CoreFormState(this.formGeneral);

  List<Widget> responsiveView() {
    List<Widget> listWidget = [];
    Widget? saveBtnView;
    List<FocusNode?> listOfFocusNode = [];

    if (widget.buttonSave != null && widget.actionSave != null) {
      saveBtnView = Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            completeText = "";
            if (_formKey.currentState!.validate()) {
              widget.actionSave!(formGeneral);
            }
            for (var count = 0; count < (formGeneral).fields!.length; count++) {
              var item = (formGeneral).fields![count];
              if (item.type == AppConstant.radioButton) {
                if (item.value == -1) {
                  // Utils.showSnackBar(context, AppConstant.str_select_gender);
                  setState(() {
                    widget.errorMessages![AppConstant.radioButton] =
                        'Please select your Gender !';
                  });
                  return;
                } else {
                  String gender = "";
                  for (Items selGender in item.items ?? []) {
                    if (selGender.value == item.value) {
                      gender = selGender.label!;
                    }
                  }

                  completeText += item.label != null
                      ? "${item.label as String} = ${gender} \n"
                      : "";
                }
              } else if (item.type == AppConstant.str_switch) {
                completeText += item.label != null
                    ? "${item.label as String} = ${item.value} \n"
                    : "";
              } else if (item.type == AppConstant.str_checkbox) {
                if (item.value == null || (item.value as List).isEmpty) {
                  setState(() {
                    widget.errorMessages![AppConstant.str_checkbox] =
                        'Please select your Language !';
                  });
                  return;
                } else {
                  String languages = "";
                  for (int number in item.value) {
                    languages += "${item.items![number].label!},";
                  }
                  languages = languages.isNotEmpty
                      ? languages.substring(0, languages.length - 1)
                      : "";
                  completeText += item.label != null
                      ? "${item.label as String} = $languages \n"
                      : "";
                }
              } else if (item.type == AppConstant.str_select) {
                if (item.value == null || (item.value as String).isEmpty) {
                  //todo write condition if you have
                  /*setState(() {
                    widget.errorMessages![AppConstant.str_checkbox] =
                    'Please select your Language !';
                  });
                  return;*/
                } else {
                  String role = "";
                  for (Items i in item.items ?? []) {
                    if (i.label == item.value) {
                      role = item.value;
                      break;
                    }
                  }

                  completeText += role.isNotEmpty
                      ? "${item.label as String} = $role \n"
                      : "";
                }
              } else if (item.type == AppConstant.str_date) {
                if (item.value == null || (item.value as String) == null) {
                  Utils.showSnackBar(
                      context, AppConstant.str_date_can_not_empty);
                  return;
                } else {
                  completeText += item.label != null
                      ? "${item.label as String} = ${item.value} \n"
                      : "";
                }
              } else if (item.type == AppConstant.strInput ||
                  item.type == AppConstant.strPassword ||
                  item.type == AppConstant.strEmail ||
                  item.type == AppConstant.strAddress ||
                  item.type == AppConstant.strTextArea ||
                  item.type == AppConstant.strTextInput) {
                setState(() {
                  completeText += item.label != null
                      ? "${item.label as String} = ${_controllers[count]!.text} \n"
                      : "";
                });
              }
            }
          },
          child: widget.buttonSave,
        ),
      );
    }
    var finalWidget = Column(
      children: [
        getTitleDesc(formGeneral.title.toString(),
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        getTitleDesc(formGeneral.description.toString(),
            const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic)),
        ListView.builder(
          shrinkWrap: true,
          itemCount: ((formGeneral).fields!.length / 2).ceil(),
          itemBuilder: (context, index) {
            final int firstIndex = index * 2;
            final int secondIndex = index * 2 + 1;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: getDyanamicViewFromJson(firstIndex, listOfFocusNode),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  if (secondIndex < (formGeneral).fields!.length)
                    Expanded(
                      child:
                          getDyanamicViewFromJson(secondIndex, listOfFocusNode),
                    ),
                  if ((formGeneral).fields!.length % 2 != 0 && secondIndex == (formGeneral).fields!.length)
                    Expanded(
                      child:
                          Container(), //length is 9 so last item display with expanded thats why added container
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
        saveBtnView ?? Container(),
        const SizedBox(
          height: 30,
        ),
        if (completeText.isNotEmpty) Text(completeText),
        InkWell(
          onTap: () {
            _pickFiles();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black87, // Border color
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(5), // Border radius
            ),
            child: const Text("Pick File"),
          ),
        ),
        _fileName != null
            ? Image.memory(
                Uint8List.fromList(_fileName!.bytes!),
                width: 400,
                height: 400,
              )
            : const Text("No file Selected"),
      ],
    );
    listWidget.add(finalWidget);
    return listWidget;
  }

  List<Widget> jsonToForm() {
    List<Widget> listWidget = [];
    List<FocusNode?> listOfFocusNode = [];

    if ((formGeneral).title != null) {
      listWidget.add(Text(
        (formGeneral).title.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ));
    }

    if ((formGeneral).description != null) {
      listWidget.add(Text(
        (formGeneral).description.toString(),
        style: const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
      ));
    }

    for (var count = 0; count < (formGeneral).fields!.length; count++) {
      var item = (formGeneral).fields![count];

      if (item.type == AppConstant.strInput ||
          item.type == AppConstant.strPassword ||
          item.type == AppConstant.strEmail ||
          item.type == AppConstant.strAddress ||
          item.type == AppConstant.strTextArea ||
          item.type == AppConstant.strTextInput) {
        var controller = _getController(count);
        if (item.value != null && (item.value as String).isNotEmpty) {
          controller.text = (item.value as String);
        }

        listWidget.add(SimpleTextView(
          controller: controller,
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages!,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
          focusList: listOfFocusNode,
        ));
      }

      if (item.type == AppConstant.radioButton) {
        listWidget.add(SimpleRadioButton(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages ?? {},
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item.type == AppConstant.str_switch) {
        listWidget.add(SimpleSwitchButton(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages!,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item.type == AppConstant.str_checkbox) {
        listWidget.add(SimpleCheckbox(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages ?? {},
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item.type == AppConstant.str_select) {
        listWidget.add(SimpleSelect(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages!,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item.type == AppConstant.str_date) {
        listWidget.add(SimpleDate(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages!,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }
    }

    if (widget.buttonSave != null && widget.actionSave != null) {
      listWidget.add(Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            completeText = "";
            if (_formKey.currentState!.validate()) {
              widget.actionSave!(formGeneral);
            }
            for (var count = 0; count < (formGeneral).fields!.length; count++) {
              var item = (formGeneral).fields![count];
              if (item.type == AppConstant.radioButton) {
                if (item.value == -1) {
                  // Utils.showSnackBar(context, AppConstant.str_select_gender);
                  setState(() {
                    widget.errorMessages![AppConstant.radioButton] =
                        'Please select your Gender !';
                  });
                  return;
                } else {
                  String gender = "";
                  for (Items selGender in item.items ?? []) {
                    if (selGender.value == item.value) {
                      gender = selGender.label!;
                    }
                  }

                  completeText += item.label != null
                      ? "${item.label as String} = ${gender} \n"
                      : "";
                }
              } else if (item.type == AppConstant.str_switch) {
                completeText += item.label != null
                    ? "${item.label as String} = ${item.value} \n"
                    : "";
              } else if (item.type == AppConstant.str_checkbox) {
                if (item.value == null || (item.value as List).isEmpty) {
                  setState(() {
                    widget.errorMessages![AppConstant.str_checkbox] =
                        'Please select your Language !';
                  });
                  return;
                } else {
                  String languages = "";
                  for (int number in item.value) {
                    languages += "${item.items![number].label!},";
                  }
                  languages = languages.isNotEmpty
                      ? languages.substring(0, languages.length - 1)
                      : "";
                  completeText += item.label != null
                      ? "${item.label as String} = $languages \n"
                      : "";
                }
              } else if (item.type == AppConstant.str_select) {
                if (item.value == null || (item.value as String).isEmpty) {
                  //todo write condition if you have
                  /*setState(() {
                    widget.errorMessages![AppConstant.str_checkbox] =
                    'Please select your Language !';
                  });
                  return;*/
                } else {
                  String role = "";
                  for (Items i in item.items ?? []) {
                    if (i.label == item.value) {
                      role = item.value;
                      break;
                    }
                  }

                  completeText += role.isNotEmpty
                      ? "${item.label as String} = $role \n"
                      : "";
                }
              } else if (item.type == AppConstant.str_date) {
                if (item.value == null || (item.value as String) == null) {
                  Utils.showSnackBar(
                      context, AppConstant.str_date_can_not_empty);
                  return;
                } else {
                  completeText += item.label != null
                      ? "${item.label as String} = ${item.value} \n"
                      : "";
                }
              } else if (item.type == AppConstant.strInput ||
                  item.type == AppConstant.strPassword ||
                  item.type == AppConstant.strEmail ||
                  item.type == AppConstant.strAddress ||
                  item.type == AppConstant.strTextArea ||
                  item.type == AppConstant.strTextInput) {
                setState(() {
                  completeText += item.label != null
                      ? "${item.label as String} = ${_controllers[count]!.text} \n"
                      : "";
                });
              }
            }
          },
          child: widget.buttonSave,
        ),
      ));
      listWidget
          .add(completeText.isNotEmpty ? Text("$completeText") : Container());

      listWidget.add(Column(children: [
        InkWell(
          onTap: () {
            _pickFiles();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black87, // Border color
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(5), // Border radius
            ),
            child: const Text("Pick File"),
          ),
        ),
        _fileName != null
            ? Image.memory(
          Uint8List.fromList(_fileName!.bytes!),
          width: 400,
          height: 400,
        )
            : const Text("No file Selected"),
      ],));
    }

    return listWidget;
  }

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  void onChange(int position, dynamic value) {
    setState(() {
      (formGeneral).fields![position].value = value;
      _handleChanged();
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      // autovalidateMode:
      //     (formGeneral as DynamicFieldModel)['autoValidated'] ?? AutovalidateMode.disabled,
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(widget.padding ?? 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              Responsive.isDesktop(context) ? responsiveView() : jsonToForm(),
        ),
      ),
    );
  }

  getTitleDesc(String data, TextStyle style) {
    if (data != null) {
      return Text(
        data.toString(),
        style: style,
      );
    } else {
      Container();
    }
  }

  Widget getDyanamicViewFromJson(int count, List<FocusNode?> listOfFocusNode) {
    var item = (formGeneral).fields![count];

    if (item.type == AppConstant.strInput ||
        item.type == AppConstant.strPassword ||
        item.type == AppConstant.strEmail ||
        item.type == AppConstant.strTextArea ||
        item.type == AppConstant.strAddress ||
        item.type == AppConstant.strTextInput) {
      var controller = _getController(count);
      if (item.value != null && (item.value as String).isNotEmpty) {
        controller.text = (item.value as String);
      }
      return SimpleTextView(
        controller: controller,
        item: item,
        onChange: onChange,
        position: count,
        decorations: widget.decorations,
        errorMessages: widget.errorMessages!,
        validations: widget.validations,
        keyboardTypes: widget.keyboardTypes,
        focusList: listOfFocusNode,
      );
    } else if (item.type == AppConstant.radioButton) {
      return SimpleRadioButton(
        item: item,
        onChange: onChange,
        position: count,
        decorations: widget.decorations,
        errorMessages: widget.errorMessages!,
        validations: widget.validations,
        keyboardTypes: widget.keyboardTypes,
      );
    } else if (item.type == AppConstant.str_switch) {
      return SimpleSwitchButton(
        item: item,
        onChange: onChange,
        position: count,
        decorations: widget.decorations,
        errorMessages: widget.errorMessages!,
        validations: widget.validations,
        keyboardTypes: widget.keyboardTypes,
      );
    } else if (item.type == AppConstant.str_checkbox) {
      return SimpleCheckbox(
        item: item,
        onChange: onChange,
        position: count,
        decorations: widget.decorations,
        errorMessages: widget.errorMessages!,
        validations: widget.validations,
        keyboardTypes: widget.keyboardTypes,
      );
    } else if (item.type == AppConstant.str_select) {
      return SimpleSelect(
        item: item,
        onChange: onChange,
        position: count,
        decorations: widget.decorations,
        errorMessages: widget.errorMessages!,
        validations: widget.validations,
        keyboardTypes: widget.keyboardTypes,
      );
    } else if (item.type == AppConstant.str_date) {
      return SimpleDate(
        item: item,
        onChange: onChange,
        position: count,
        decorations: widget.decorations,
        errorMessages: widget.errorMessages!,
        validations: widget.validations,
        keyboardTypes: widget.keyboardTypes,
      );
    } else {
      return Container();
    }
  }

  // Function to get controller for a specific index
  TextEditingController _getController(int index) {
    // Create a controller if not exists
    _controllers.putIfAbsent(index, () => TextEditingController());
    return _controllers[index]!;
  }

  void _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: "Select File",
        initialDirectory: "",
        lockParentWindow: _lockParentWindow,
      ));
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName =
          (_paths != null ? _paths!.files.first : '...') as PlatformFile?;
    });
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
    });
  }

  void _logException(String message) {
    print(message);
  }
}
