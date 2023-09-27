import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:flutter/material.dart';

class RadioMenuModel {
  final dynamic value;
  final bool isSelected;
  final String labelText;
  final dynamic groupValue;

  RadioMenuModel({
    required this.value,
    required this.labelText,
    required this.groupValue,
    required this.isSelected,
  });
}

class InnerRadioButton extends StatefulWidget {
  final bool isDisabled;
  final Color? primaryColor;
  final void Function(dynamic)? onChanged;
  final List<RadioMenuModel> choices;

  const InnerRadioButton({
    super.key,
    this.primaryColor,
    this.isDisabled = false,
    required this.choices,
    required this.onChanged,
  });

  @override
  InnerRadioButtonState createState() => InnerRadioButtonState();
}

class InnerRadioButtonState extends State<InnerRadioButton> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildSelectionButton({
    value,
    groupValue,
    bool? isSelected,
    String? labelText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected! ? ColorLibrary.themeColor_100 : ColorLibrary.white,
        border: Border.all(
          strokeAlign:  1,
          color: isSelected ? ColorLibrary.white : ColorLibrary.lightGray,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: RadioListTile<dynamic>(
        value: value,
        onChanged: widget.isDisabled ? null : widget.onChanged ?? (_) {},
        title: Text(
          labelText!,
          style: CustomTextStyles.labelSmall,
        ),
        selected: isSelected,
        groupValue: groupValue,
        activeColor: ColorLibrary.themeColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttonList = [];
    for (var e in widget.choices) {
      buttonList.add(
        buildSelectionButton(
          value: e.value,
          labelText: e.labelText,
          groupValue: e.groupValue,
          isSelected: e.isSelected,
        ),
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      itemCount: buttonList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return  buttonList[index];
      },
    );
  }
}
