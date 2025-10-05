import 'package:flat_logging/core/utils/constants/extension/validator.dart';
import 'package:flat_logging/core/utils/media/icons_strings.dart';
import 'package:flat_logging/core/utils/media/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextFieldType type;
  final bool? isPasswordVisible;
  final bool toValidate;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap, onIconTap;
  final String? hintText;
  final bool isStartDate;
  final TextInputType? keyboardType;
  final String? labelText;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.type,
    this.validator,
    this.isPasswordVisible,
    this.toValidate = true,
    this.onFieldSubmitted,
    this.onIconTap,
    this.hintText,
    this.isStartDate = true,
    this.keyboardType,
    this.labelText,
    this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextInputType? keyboardType = this.keyboardType;
    String? labelText = this.labelText;
    IconData? prefixIcon = this.prefixIcon;
    Widget? suffixIcon;
    FormFieldValidator<String>? validator = this.validator;
    List<TextInputFormatter>? inputFormatters;
    bool? isPasswordVisible;

    switch (type) {
      case TextFieldType.date:
        keyboardType = TextInputType.datetime;
        labelText = labelText ?? (isStartDate ? HTexts.startDate : HTexts.endDate);
        prefixIcon = isStartDate ? HIcons.startDate : HIcons.endDate;
        // validator = validator ?? (value) => value?.validateDate();
        break;
      case TextFieldType.general:
        keyboardType = TextInputType.text;
        labelText = hintText ?? '';
        prefixIcon = prefixIcon ?? Icons.text_fields;
        isPasswordVisible = isPasswordVisible;

        validator = validator ?? (value) => value?.validateNotEmpty(labelText!);
        break;
      case TextFieldType.name:
        keyboardType = TextInputType.name;
        labelText = labelText ?? HTexts.name;
        prefixIcon = prefixIcon ?? HIcons.name;
        validator = validator ?? (value) => value?.validateAlphaWithSpace(HTexts.name);
        break;
    }

    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: toValidate ? validator : null,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(prefixIcon: Icon(prefixIcon), labelText: labelText, hintText: hintText ?? labelText, suffixIcon: suffixIcon),
      obscureText: (isPasswordVisible ?? false),
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: type == TextFieldType.date,
    );
  }
}

enum TextFieldType { date, general, name }
