import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget { //статичный виджет
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller, //обязательный параметр
    required this.focusNode,
    required this.labelText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField( //текстовое поле
      controller: controller, //поле для ввода
      focusNode: focusNode, //статус поля ввода (акт?)
      obscureText: obscureText, //поле пароля (точки)
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters, //фильтр разрешений
      validator: validator, //проверка корректности
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.pinkAccent) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}