import 'package:flutter/material.dart';
import 'package:budz/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budz/bloc/external/external.dart';

class UserAccCubit extends Cubit<UserAccState> {
  final UserDataExternal doGetUserData;

  UserAccCubit({
    required this.doGetUserData,
  }) : super(UserAccInitialState());

  void getUserData(BuildContext context) async {
    emit(UserDataLoadingState(true));

    var result = await doGetUserData.getUserData(context);

    emit(UserAccountDataSucessState(result));
  }
}
