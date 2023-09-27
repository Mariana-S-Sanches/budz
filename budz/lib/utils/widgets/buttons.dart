// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:budz/utils/color_library.dart';

class PrimaryButton extends StatelessWidget {
  ///ajusta o tipo do texto para perder tamanho caso nao caiba o widget na tela com `BoxFit.scaleDown`.
  final BoxFit? fit;
  final bool isDisabled;
  final String textButton;
  final Color? colorButton;
  final void Function()? onTap;
  String? iconPath;

  PrimaryButton({
    Key? key,
    this.fit,
    this.colorButton,
    this.isDisabled = false,
    required this.onTap,
    required this.textButton,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled == false ? onTap : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: colorButton ?? ColorLibrary.themeColor,
        backgroundColor: colorButton ?? ColorLibrary.themeColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FittedBox(
                  fit: fit ?? BoxFit.scaleDown,
                  child: Text(
                    textButton,
                    style: CustomTextStyles.labelButton.copyWith(color: ColorLibrary.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final BoxFit? fit;
  final String textButton;
  final TextStyle? style;
  TextDecoration? decoration;
  final void Function()? onTap;

  CustomTextButton({
    Key? key,
    this.fit,
    this.style,
    this.decoration,
    required this.onTap,
    required this.textButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        child: SizedBox(
          child: FittedBox(
            fit: fit ?? BoxFit.scaleDown,
            child: Text(
              textButton,
              style: style ?? CustomTextStyles.labelButton,
            ),
          ),
        ),
      ),
    );
  }
}
