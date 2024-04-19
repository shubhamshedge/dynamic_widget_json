import 'package:dyanamic_form_with_json/dynamic_form_2/dynamic_field_model.dart';
import 'package:dyanamic_form_with_json/dynamic_form_2/utils.dart';
import 'package:flutter/material.dart';

class SimpleDate extends StatefulWidget {
  const SimpleDate({
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
  _SimpleDate createState() => _SimpleDate();
}

class _SimpleDate extends State<SimpleDate> {
  late Fields item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    Widget label = const SizedBox.shrink();
    if (Utils.labelHidden(item)) {
      label = Text(
        item.label.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label,
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
                child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: item.value ?? "",
                //prefixIcon: Icon(Icons.date_range_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    selectDate();
                  },
                  icon: const Icon(Icons.calendar_today_rounded),
                ),
              ),
            )),
          ],
        )
      ],
    );
  }

  Future selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 360)),
        firstDate: DateTime.now().subtract(const Duration(days: 360)),
        lastDate: DateTime.now().add(const Duration(days: 360)));
    if (picked != null) {
      String date =
          "${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        item.value = date;
        widget.onChange(widget.position, date);
      });
    }
  }
}
