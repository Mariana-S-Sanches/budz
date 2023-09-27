import 'package:flutter/material.dart';
import 'package:budz/bloc/user_cubit.dart';
import 'package:budz/bloc/user_state.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:budz/utils/widgets/modal.dart';
import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/picture_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budz/utils/navigator_fade.dart';
import 'package:budz/utils/widgets/buttons.dart';
import 'package:budz/utils/strings_library.dart';
import 'package:budz/utils/widgets/dropdown.dart';
import 'package:budz/models/user_data_model.dart';
import 'package:budz/utils/widgets/form_fields.dart';
import 'package:budz/utils/widgets/bottom_sheet.dart';
import 'package:budz/modules/delete_acc_journey/delete_acc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.userAccount}) : super(key: key);

  final UserAccount userAccount;
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  final List<String> items = [
    StringsLib.male,
    StringsLib.female,
  ];
  String? selectedValue;

  @override
  void initState() {
    controllerName = TextEditingController(text: widget.userAccount.user.fullname);
    controllerEmail = TextEditingController(text: widget.userAccount.user.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserAccCubit, UserAccState>(listener: (context, state) {
      if (state is EditingProfileDataState) {
        context.read<UserAccCubit>().getUserData(context);
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: ColorLibrary.white,
        appBar: AppBar(
          backgroundColor: ColorLibrary.white,
          title: Text(
            StringsLib.editProfile,
            style: CustomTextStyles.title,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(PicturePaths.john),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomTextButton(
                  onTap: () {
                    genericBottomSheet(
                      context: context,
                      widget: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: ColorLibrary.white,
                                border: Border.all(
                                  strokeAlign: 1,
                                  color: ColorLibrary.lightGray,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: ListTile(
                                leading: SvgPicture.asset(PicturePaths.camera),
                                title: Text(
                                  StringsLib.takePicture,
                                  style: CustomTextStyles.defaultText,
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorLibrary.lightGray,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorLibrary.white,
                                  border: Border.all(
                                    strokeAlign: 1,
                                    color: ColorLibrary.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  leading: SvgPicture.asset(PicturePaths.addPhoto),
                                  title: Text(
                                    StringsLib.selectPicture,
                                    style: CustomTextStyles.defaultText,
                                  ),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: ColorLibrary.lightGray,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  textButton: StringsLib.changeProfilePic,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 20, bottom: 10, top: 20),
                child: Text(
                  StringsLib.name,
                  style: CustomTextStyles.formText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomTextField(
                  controller: controllerName,
                  labelText: '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 20, bottom: 10, top: 20),
                child: Text(
                  StringsLib.email,
                  style: CustomTextStyles.formText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomTextField(
                  controller: controllerEmail,
                  labelText: '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 20, bottom: 10, top: 20),
                child: Text(
                  StringsLib.gender,
                  style: CustomTextStyles.formText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDropdownButton(
                        value: selectedValue,
                        hint: StringsLib.selectOption,
                        items: items
                            .map(
                              (item) => CustomDropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onTap: () {
                          UserAccount account = widget.userAccount;
                          account.user.fullname = controllerName.text;
                          account.user.email = controllerEmail.text;
                          context.read<UserAccCubit>().setEditProfile(context, account);
                        },
                        textButton: StringsLib.save,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is DeletingUserAccountState
                        ? CustomTextButton(
                            onTap: () => SimpleDialogModalOneButton(context, bodyText: StringsLib.deletingAccDesc, buttonText: 'OK'),
                            textButton: StringsLib.deletingAcc,
                            style: CustomTextStyles.labelButton.copyWith(
                              color: ColorLibrary.textColor,
                            ),
                          )
                        : CustomTextButton(
                            onTap: () => bottomSheetDeleteAccount(),
                            textButton: StringsLib.deleteAcc,
                            style: CustomTextStyles.labelButton.copyWith(
                              color: ColorLibrary.textColor,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  bottomSheetDeleteAccount() {
    return genericBottomSheet(
      context: context,
      scroll: true,
      widget: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Text(
              StringsLib.finishJourney,
              style: CustomTextStyles.title,
              textAlign: TextAlign.center,
            ),
          ),
          SvgPicture.asset(PicturePaths.sad),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Text(
              StringsLib.infoDelete,
              style: CustomTextStyles.defaultText,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        RouteNavigator(page: const DeleteAccountJourney()),
                      );
                    },
                    colorButton: ColorLibrary.red,
                    textButton: StringsLib.deleteAcc.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  textButton: StringsLib.cancel,
                  style: CustomTextStyles.labelButton,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
