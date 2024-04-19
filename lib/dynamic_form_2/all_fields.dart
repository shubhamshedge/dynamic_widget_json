import 'dart:convert';
import 'package:dyanamic_form_with_json/dynamic_form_2/dynamic_field_model.dart';
import 'package:flutter/material.dart';

import 'form_element.dart';

class AllFields extends StatefulWidget {
  AllFields({super.key});

  @override
  _AllFields createState() => _AllFields();
}

class _AllFields extends State<AllFields> {
  DynamicFieldModel? form;
  dynamic response;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getFromJson();
    });
  }

  getFromJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/field.json");
    // form = json.encode(data);
    Map<String, dynamic> jsonMap = jsonDecode(data);
    setState(() {
      form = DynamicFieldModel.fromJson(jsonMap);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: <Widget>[
                FormElement(
                  form: form,
                  onChanged: (dynamic response) {
                    this.response = response;
                    //print(jsonEncode(response));
                  },
                  actionSave: (data) {
                    print("Value Recieved");
                    // print(jsonEncode(data));
                  },
                  errorMessages: {},
                  autovalidateMode: AutovalidateMode.always,
                  buttonSave: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Background color
                      borderRadius: BorderRadius.circular(10), // Button shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 3,
                    child: const Center(
                      child: Text("Send",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ]),
            ),
    );
  }
}
