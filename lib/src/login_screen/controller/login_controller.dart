import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../../../services/notification_services.dart';
import '../../home_screen/view/home_view.dart';
import '../widget/login_screen_alertdialog.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  login() async {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.text)
        .where('password', isEqualTo: password.text)
        .limit(1)
        .get();

    if (res.docs.length > 0) {
      var userDetails = res.docs[0];
      var profileImage = userDetails['image'];

      if (userDetails['image'] == '') {
        profileImage =
            'https://firebasestorage.googleapis.com/v0/b/documentmanagement-ad3ca.appspot.com/o/loginlogo.png?alt=media&token=97a8696c-fd0c-453f-843e-548c2c3c3491';
      }
      Get.find<StorageServices>().saveCredentials(
        id: userDetails.id,
        email: userDetails['email'],
        password: userDetails['password'],
        firstname: userDetails['firstname'],
        lastname: userDetails['lastname'],
        image: profileImage,
        contactno: userDetails['contactno'],
      );
      Get.offAll(() => HomeScreenView());
      Get.find<NotificationServices>().getToken();
    } else {
      LoginAlertDialog.showAccountNotFound();
    }
  }
}
