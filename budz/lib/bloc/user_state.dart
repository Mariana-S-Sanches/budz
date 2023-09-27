import 'package:budz/models/user_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserAccState extends Equatable {}

class UserAccInitialState extends UserAccState {
  @override
  List<Object> get props => [];
}

class UserDataLoadingState extends UserAccState {
  final bool prop;

  UserDataLoadingState(this.prop);

  @override
  List<Object> get props => [prop];
}

class UserAccountDataSucessState extends UserAccState {
  final UserAccount userAcc;

  UserAccountDataSucessState(this.userAcc);

  @override
  List<Object> get props => [userAcc];
}

class EditingProfileDataState extends UserAccState {
  final bool editing;

  EditingProfileDataState(this.editing);

  @override
  List<Object> get props => [editing];
}

class DeletingUserAccountState extends UserAccState {
  final bool deleting;

  DeletingUserAccountState(this.deleting);

  @override
  List<Object> get props => [deleting];
}
