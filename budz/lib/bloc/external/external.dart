import 'dart:io';
import 'package:flutter/material.dart';
import 'package:budz/models/user_data_model.dart';

class UserDataExternal {
  Future<UserAccount> getUserData(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString("fake_back_end/back_end.json");
      UserAccount drivers = userAccFromJson(data);
      return drivers;
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception(e);
    }
  }
}

class OverwriteData {
  Future overwriteData(String contents) async {
    try {
      String jsonFile = "fake_back_end/back_end.json";
      File file = File(jsonFile);
      file.writeAsStringSync(contents);
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception(e);
    }
  }
}
