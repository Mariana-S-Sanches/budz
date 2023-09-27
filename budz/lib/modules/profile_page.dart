import 'package:flutter/material.dart';
import 'package:budz/bloc/user_cubit.dart';
import 'package:budz/bloc/user_state.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:budz/utils/picture_paths.dart';
import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/navigator_fade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budz/utils/strings_library.dart';
import 'package:budz/modules/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<UserAccCubit>().getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserAccCubit, UserAccState>(
      listener: (context, state) {
        if (state is EditingProfileDataState) {
          context.read<UserAccCubit>().getUserData(context);
        }
      },
      builder: (context, state) {
        if (state is UserAccountDataSucessState) {
          return Scaffold(
            backgroundColor: ColorLibrary.background,
            appBar: AppBar(
              toolbarHeight: kToolbarHeight + 20,
              backgroundColor: ColorLibrary.white,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(PicturePaths.john),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.userAcc.user.nickname,
                            style: CustomTextStyles.title,
                          ),
                          Text(
                            state.userAcc.user.email,
                            style: CustomTextStyles.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                        child: Column(
                          children: [
                            componentListTile(PicturePaths.pets, StringsLib.myPets),
                            const Divider(thickness: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    RouteNavigator(page: EditProfilePage(userAccount: state.userAcc)),
                                  );
                                },
                                leading: SvgPicture.asset(PicturePaths.profile),
                                title: Text(
                                  StringsLib.editProfile,
                                  style: CustomTextStyles.defaultText,
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorLibrary.lightGray,
                                ),
                              ),
                            ),
                            const Divider(thickness: 1),
                            componentListTile(PicturePaths.clicker, StringsLib.tools),
                            const Divider(thickness: 1),
                            componentListTile(PicturePaths.premium, StringsLib.manageSub),
                            const Divider(thickness: 1),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                              child: ListTile(
                                leading: SvgPicture.asset(PicturePaths.lock),
                                title: Text(
                                  StringsLib.changePassword,
                                  style: CustomTextStyles.defaultText,
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorLibrary.lightGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorLibrary.white,
                            border: Border.all(
                              strokeAlign: 1,
                              color: ColorLibrary.lightGray,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: componentListTile(PicturePaths.logout, StringsLib.exitApp),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    StringsLib.version,
                    style: CustomTextStyles.textSmall,
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: Text(
            'Carregando perfil\n:D',
            style: CustomTextStyles.title,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  componentListTile(String image, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: ListTile(
        leading: SvgPicture.asset(image),
        title: Text(
          text,
          style: CustomTextStyles.defaultText,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: ColorLibrary.lightGray,
        ),
      ),
    );
  }
}
