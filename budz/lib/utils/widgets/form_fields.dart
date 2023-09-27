// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:budz/utils/color_library.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  final Key? textFieldKey;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onChanged; 
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    this.onTap,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.textFieldKey,
    required this.labelText,
    required this.controller,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: ColorLibrary.lightGray),
      child: TextFormField(
        maxLines: 1,
        onTap: onTap,
        key: textFieldKey,
        cursorColor: ColorLibrary.lightGray,
        onChanged: onChanged ?? (_) {},
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator ?? (_) => null,
        style: CustomTextStyles.labelSmall,
        focusNode: focusNode,
        decoration: InputDecoration(
          counterText: '',
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorLibrary.red,
              width: 2,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          hintText: labelText,
          labelStyle: CustomTextStyles.labelSmall,
        ),
      ),
    );
  }
}
