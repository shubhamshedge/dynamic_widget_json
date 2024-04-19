import 'package:dyanamic_form_with_json/dynamic_form_2/app_constant.dart';

class DynamicFieldModel {
  String? title;
  String? description;
  List<Fields>? fields;

  DynamicFieldModel({this.title, this.description, this.fields});

  DynamicFieldModel.fromJson(Map<String, dynamic> json) {
    title = json[AppConstant.strTitle];
    description = json[AppConstant.strDesc];
    if (json[AppConstant.strFields] != null) {
      fields = <Fields>[];
      json[AppConstant.strFields].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[AppConstant.strTitle] = title;
    data[AppConstant.strDesc] = description;
    if (fields != null) {
      data[AppConstant.strFields] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  String? key;
  String? type;
  String? label;
  bool? hiddenLabel;
  String? placeholder;
  String? decoration;
  String? helpText;
  String? keyboardType;
  String? pattern;
  Map<String, dynamic>? validator;
  dynamic value;
  bool? required;
  int? maxline;
  List<Items>? items;

  Fields(
      {this.key,
      this.type,
      this.label,
      this.hiddenLabel,
      this.placeholder,
      this.decoration,
      this.helpText,
      this.keyboardType,
      this.pattern,
      this.validator,
      this.value,
      this.required,
      this.maxline,
      this.items});

  Fields.fromJson(Map<String, dynamic> json) {
    key = json[AppConstant.strKey];
    type = json[AppConstant.strType];
    label = json[AppConstant.strHiddenLabel];
    hiddenLabel = json[AppConstant.strHiddenLabel] ?? false;
    placeholder = json[AppConstant.strPlaceholder];
    decoration = json[AppConstant.strDecoration];
    helpText = json[AppConstant.strHelpText];
    keyboardType = json[AppConstant.strKeyboardType];
    pattern = json[AppConstant.strPattern];

    if (json[AppConstant.strValidator] != null) {
      validator = {};
      json[AppConstant.strValidator].forEach((k, v) {
        validator?[k] = ValidatorItem.fromJson(v);
      });
    }
    value = json[AppConstant.strValue];
    required = json[AppConstant.strRequired];
    maxline = json[AppConstant.strMaxline];
    if (json[AppConstant.strItems] != null) {
      items = <Items>[];
      json[AppConstant.strItems].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['type'] = type;
    data['label'] = label;
    data['placeholder'] = placeholder;
    data['value'] = value;
    data['required'] = required;
    data['pattern'] = pattern;
    data['maxline'] = maxline;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (validator != null) {
      data['validator'] = validator!.map((k, v) => v.toJson());
    }
    return data;
  }
}

class Items {
  String? label;
  dynamic value;

  Items({this.label, this.value});

  Items.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class ValidatorItem {
  String? label;
  dynamic value;

  ValidatorItem({this.label, this.value});

  ValidatorItem.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
