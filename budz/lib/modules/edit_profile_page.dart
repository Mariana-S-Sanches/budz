import 'package:budz/utils/buttons.dart';
import 'package:budz/utils/form_fields.dart';
import 'package:budz/utils/picture_paths.dart';
import 'package:budz/utils/strings_library.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:budz/utils/color_library.dart';
import 'package:budz/models/user_data_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.userAccount}) : super(key: key);

  final UserAccount userAccount;
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  @override
  void initState() {
    controllerName = TextEditingController(text: widget.userAccount.user.fullname);
    controllerEmail = TextEditingController(text: widget.userAccount.user.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: () {},
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
          ],
        ),
      ),
    );
  }
}
