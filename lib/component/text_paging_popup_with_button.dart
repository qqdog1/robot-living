import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'text_paging_popup.dart';

class TextPagingPopupWithButton extends TextPagingPopup {
  final VoidCallback buttonCallback;
  final String buttonText;

  const TextPagingPopupWithButton({
    super.key,
    required super.pageContents,
    required this.buttonCallback,
    required this.buttonText,
  });

  @override
  TextPagingPopupWithButtonState createState() => TextPagingPopupWithButtonState();
}

class TextPagingPopupWithButtonState extends TextPagingPopupState {
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.pageContents[currentPage - 1], // 顯示當前頁面的內容
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (widget as TextPagingPopupWithButton).buttonCallback,
            child: Text((widget as TextPagingPopupWithButton).buttonText),
          ),
        ],
      ),
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
        if (currentPage < totalPages)
          IconButton(
            icon: const Icon(FontAwesomeIcons.caretRight),
            onPressed: () {
              setState(() {
                currentPage++;
              });
            },
          ),
        if (currentPage == totalPages)
          const SizedBox(height: 50, width: 48),
      ],
    );
  }
}
