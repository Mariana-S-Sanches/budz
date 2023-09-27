import 'package:flutter/material.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/navigator_fade.dart';
import 'package:budz/utils/widgets/buttons.dart';
import 'package:budz/utils/strings_library.dart';
import 'package:budz/utils/widgets/radio_menu.dart';
import 'package:budz/modules/delete_acc_journey/deleted_account.dart';

class DeleteAccountJourney extends StatefulWidget {
  const DeleteAccountJourney({Key? key}) : super(key: key);

  @override
  DeleteAccountJourneyState createState() => DeleteAccountJourneyState();
}

class DeleteAccountJourneyState extends State<DeleteAccountJourney> {
  var selected = "";
  Motives motives = Motives.other;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorLibrary.white,
      appBar: AppBar(
        backgroundColor: ColorLibrary.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: Text(
              StringsLib.deletetitle,
              style: CustomTextStyles.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InnerRadioButton(
              onChanged: (value) {
                setState(() {
                  motives = value;
                });
              },
              choices: [
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive1,
                  value: Motives.usage,
                  isSelected: motives == Motives.usage,
                ),
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive2,
                  value: Motives.amount,
                  isSelected: motives == Motives.amount,
                ),
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive3,
                  value: Motives.services,
                  isSelected: motives == Motives.services,
                ),
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive4,
                  value: Motives.problems,
                  isSelected: motives == Motives.problems,
                ),
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive5,
                  value: Motives.content,
                  isSelected: motives == Motives.content,
                ),
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive6,
                  value: Motives.experience,
                  isSelected: motives == Motives.experience,
                ),
                RadioMenuModel(
                  groupValue: motives,
                  labelText: StringsLib.deleteMotive7,
                  value: Motives.other,
                  isSelected: motives == Motives.other,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        RouteNavigator(page: const DeletedAccountPage()),
                      );
                    },
                    textButton: StringsLib.continueDelete.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
