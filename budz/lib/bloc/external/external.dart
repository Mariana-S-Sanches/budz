import 'package:flutter/material.dart';
import 'package:budz/models/user_data_model.dart';

const path = "fake_back_end/back_end.json";

class UserDataExternal {
  Future<UserAccount> getUserData(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString(path);
      UserAccount drivers = userAccFromJson(data);
      return drivers;
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception(e);
    }
  }
}