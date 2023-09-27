// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:budz/utils/text_styles.dart';

SimpleDialogModalOneButton(
  BuildContext context, {
  String? title,
  Function()? onTap,
  required String bodyText,
  required String buttonText,
}) {
  showGeneralDialog(
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black26,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      backgroundColor: ColorLibrary.white,
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(title),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(bodyText, style: CustomTextStyles.defaultText),
              ),
            ],
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: PrimaryButton(
                  onTap: onTap ??
                      () {
                        Navigator.pop(context);
                      },
                  textButton: buttonText,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
