import 'dart:convert';

UserAccount userAccFromJson(String str) => UserAccount.fromJson(json.decode(str));

String userAccToJson(UserAccount data) => json.encode(data.toJson());

class UserAccount {
  List<String> pets;
  User user;
  Subscription subscription;

  UserAccount({
    required this.pets,
    required this.user,
    required this.subscription,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        pets: List<String>.from(json["pets"].map((x) => x)),
        user: User.fromJson(json["user"]),
        subscription: Subscription.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "pets": List<dynamic>.from(pets.map((x) => x)),
        "user": user.toJson(),
        "subscription": subscription.toJson(),
      };
}

class Subscription {
  String id;
  String userId;
  String userType;
  dynamic createdAt;
  dynamic updatedAt;
  String subscriptionType;
  String subscriptionStatus;

  Subscription({
    required this.id,
    required this.userId,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    required this.subscriptionType,
    required this.subscriptionStatus,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        userType: json["userType"],
        createdAt: json["createdAt"],
        userId: json["userId"],
        updatedAt: json["updatedAt"],
        subscriptionStatus: json["subscriptionStatus"],
        id: json["id"],
        subscriptionType: json["subscriptionType"],
      );

  Map<String, dynamic> toJson() => {
        "userType": userType,
        "createdAt": createdAt,
        "userId": userId,
        "updatedAt": updatedAt,
        "subscriptionStatus": subscriptionStatus,
        "id": id,
        "subscriptionType": subscriptionType,
      };
}

class User {
  String id;
  String email;
  dynamic gender;
  String password;
  String fullname;
  String nickname;
  dynamic birthdate;
  dynamic photoUrl;
  dynamic pushAllow;
  dynamic phoneNumber;
  String generalPetId;
  DateTime updatedDate;
  DateTime createdDate;
  dynamic isThirdPartyLogin;
  dynamic thirdPartyLoginIdToken;
  dynamic thirdPartyLoginServerAuthCode;

  User({
    required this.email,
    required this.id,
    required this.gender,
    required this.password,
    required this.nickname,
    required this.photoUrl,
    required this.fullname,
    required this.pushAllow,
    required this.birthdate,
    required this.updatedDate,
    required this.createdDate,
    required this.phoneNumber,
    required this.generalPetId,
    required this.isThirdPartyLogin,
    required this.thirdPartyLoginIdToken,
    required this.thirdPartyLoginServerAuthCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        generalPetId: json["generalPetID"],
        thirdPartyLoginIdToken: json["thirdPartyLoginIdToken"],
        pushAllow: json["pushAllow"],
        fullname: json["fullname"],
        thirdPartyLoginServerAuthCode: json["thirdPartyLoginServerAuthCode"],
        photoUrl: json["photoUrl"],
        updatedDate: DateTime.parse(json["updatedDate"]),
        createdDate: DateTime.parse(json["createdDate"]),
        isThirdPartyLogin: json["isThirdPartyLogin"],
        phoneNumber: json["phoneNumber"],
        id: json["id"],
        nickname: json["nickname"],
        birthdate: json["birthdate"],
        gender: json["gender"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "generalPetID": generalPetId,
        "thirdPartyLoginIdToken": thirdPartyLoginIdToken,
        "pushAllow": pushAllow,
        "fullname": fullname,
        "thirdPartyLoginServerAuthCode": thirdPartyLoginServerAuthCode,
        "photoUrl": photoUrl,
        "updatedDate": updatedDate.toIso8601String(),
        "createdDate": createdDate.toIso8601String(),
        "isThirdPartyLogin": isThirdPartyLogin,
        "phoneNumber": phoneNumber,
        "id": id,
        "nickname": nickname,
        "birthdate": birthdate,
        "gender": gender,
        "password": password,
      };
}
