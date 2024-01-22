import 'package:flutter/material.dart';

class Combobox extends StatefulWidget {
  final String? defaultItem;
  final List<String> items;
  final ValueChanged<String?>? onItemChanged;

  const Combobox({
    super.key,
    this.defaultItem,
    required this.items,
    this.onItemChanged,
  });

  @override
  _Combobox createState() => _Combobox();
}

class _Combobox extends State<Combobox> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.defaultItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue;
            });
            widget.onItemChanged?.call(newValue);
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
