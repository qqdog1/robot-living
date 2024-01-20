import 'package:flutter/material.dart';

class Combobox extends StatefulWidget {
  final String defaultItem;
  final List<String> items;

  const Combobox({
    super.key,
    required this.defaultItem,
    required this.items,
  });

  @override
  _Combobox createState() => _Combobox();
}

class _Combobox extends State<Combobox> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.defaultItem; // 在 initState 中进行初始化
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 避免佔用過多空間
      children: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
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
