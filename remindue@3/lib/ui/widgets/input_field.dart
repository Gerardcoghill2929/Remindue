import 'package:flutter/material.dart';
import 'package:remindue/ui/theme.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final bool isColorBackground;
  final bool ignoreDarkMode;
  final Widget? widget;
  const MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    this.obscureText = false,
    this.isColorBackground = false,
    this.ignoreDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputTextStyle = ignoreDarkMode
        ? subtitleStyle.copyWith(color: Colors.black)
        : subtitleStyle;
    final labelTextStyle = isColorBackground
        ? titleStyle.copyWith(color: Colors.white)
        : titleStyle;

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: labelTextStyle),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.only(left: 14.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
              color: isColorBackground ? Colors.white : Colors.transparent,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode
                        ? Colors.grey[100]
                        : Colors.grey[700],
                    controller: controller,
                    style: inputTextStyle,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: inputTextStyle,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                widget == null ? Container() : Container(child: widget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
