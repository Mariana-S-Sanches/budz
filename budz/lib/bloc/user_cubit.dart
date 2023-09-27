import 'package:flutter/material.dart';
import 'package:budz/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budz/models/user_data_model.dart';
import 'package:budz/bloc/external/external.dart';

class UserAccCubit extends Cubit<UserAccState> {
  final UserDataExternal doGetUserData;
  final OverwriteData overwriteData;

  UserAccCubit({
    required this.doGetUserData,
    required this.overwriteData,
  }) : super(UserAccInitialState());

  void getUserData(BuildContext context) async {
    emit(UserDataLoadingState(true));

    var result = await doGetUserData.getUserData(context);

    emit(UserAccountDataSucessState(result));
  }

  void setEditProfile(BuildContext context, UserAccount user) async {
    emit(UserDataLoadingState(true));
    overwriteData.overwriteData(userAccToJson(user));

    emit(EditingProfileDataState(true));
  }

  bool? isDeleting;
  deletingAccount(bool delete) {
    isDeleting = delete;
    emit(DeletingUserAccountState(isDeleting!));
  }
}
