import 'package:flutter/material.dart';
import 'package:budz/utils/color_library.dart';

genericBottomSheet({
  required Widget widget,
  required BuildContext context,
  double? height,
  bool scroll = false,
  bool alignmentCenter = false,
}) {
  return showModalBottomSheet(
    context: context,
    constraints: BoxConstraints.loose(
      Size(
        MediaQuery.of(context).size.width,
        height ?? MediaQuery.of(context).size.height * 0.85,
      ),
    ),
    isDismissible: true,
    useRootNavigator: false,
    isScrollControlled: scroll,
    backgroundColor: ColorLibrary.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: ColorLibrary.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            crossAxisAlignment: alignmentCenter ? WrapCrossAlignment.center : WrapCrossAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 145),
                height: MediaQuery.of(context).size.height * 0.006,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: ColorLibrary.lightGray,
                ),
              ),
              Container(
                child: widget,
              ),
            ],
          ),
        ),
      );
    },
  );
}
