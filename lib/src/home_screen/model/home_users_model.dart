import 'dart:convert';

import 'package:get/get.dart';

List<UsersModel> usersModelFromJson(String str) =>
    List<UsersModel>.from(json.decode(str).map((x) => UsersModel.fromJson(x)));

String usersModelToJson(List<UsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersModel {
  String id;
  String firstname;
  String lastname;
  String email;
  String image;
  RxBool isSelected;
  String contactno;

  UsersModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.image,
    required this.email,
    required this.contactno,
    required this.isSelected,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        isSelected: false.obs,
        image: json["image"],
        contactno: json["contactno"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "isSelected": isSelected,
        "image": image,
        "lastname": lastname,
        "email": email,
        "contactno": contactno,
      };
}
