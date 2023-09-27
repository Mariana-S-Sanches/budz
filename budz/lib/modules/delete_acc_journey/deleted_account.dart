import 'package:flutter/material.dart';
import 'package:budz/bloc/user_cubit.dart';
import 'package:budz/bloc/user_state.dart';
import 'package:budz/utils/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:budz/utils/color_library.dart';
import 'package:budz/utils/picture_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budz/utils/strings_library.dart';
import 'package:budz/utils/widgets/buttons.dart';

class DeletedAccountPage extends StatefulWidget {
  const DeletedAccountPage({Key? key}) : super(key: key);

  @override
  DeletedAccountPageState createState() => DeletedAccountPageState();
}

class DeletedAccountPageState extends State<DeletedAccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserAccCubit, UserAccState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorLibrary.white,
            appBar: AppBar(
              backgroundColor: ColorLibrary.white,
              automaticallyImplyLeading: false,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [SvgPicture.asset(PicturePaths.logo)],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SvgPicture.asset(PicturePaths.goodbye),
                      Text(
                        StringsLib.deletedAcc,
                        style: CustomTextStyles.title,
                      ),
                      Text(
                        StringsLib.deletedAccDescription,
                        style: CustomTextStyles.defaultText,
                        textAlign: TextAlign.center,
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
                            context.read<UserAccCubit>().deletingAccount(true);
                            Navigator.pop(
                              context,
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
        });
  }
}
