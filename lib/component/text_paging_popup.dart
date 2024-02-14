import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextPagingPopup extends StatefulWidget {
  final int totalPages;
  final List<Widget> pageContents;

  const TextPagingPopup({
    super.key,
    required this.totalPages,
    required this.pageContents,
  });

  @override
  _TextPagingPopupState createState() => _TextPagingPopupState();
}

class _TextPagingPopupState extends State<TextPagingPopup> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: const Icon(FontAwesomeIcons.xmark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      content: widget.pageContents[currentPage - 1], // 顯示當前頁面的內容
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        if (currentPage == 1)
          const SizedBox(height: 50, width: 48),
        if (currentPage > 1)
          IconButton(
            icon: const Icon(FontAwesomeIcons.caretLeft),
            onPressed: () {
              setState(() {
                currentPage--;
              });
            },
          ),
        if (currentPage < widget.totalPages)
          IconButton(
            icon: const Icon(FontAwesomeIcons.caretRight),
            onPressed: () {
              setState(() {
                currentPage++;
              });
            },
          ),
        if (currentPage == widget.totalPages)
          const SizedBox(height: 50, width: 48),
      ],
    );
  }
}