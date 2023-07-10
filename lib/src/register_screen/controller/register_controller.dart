import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../otp_screen/view/otp_view.dart';
import '../widget/register_alertdialog.dart';

class RegistrationController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController contact = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String verifIDReceived = "";

  RxBool isVerifyingNumber = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  RxInt toInput = 0.obs;

  getBack() async {
    if (toInput.value == 0) {
      Get.back();
    } else {
      toInput.value--;
    }
  }

  checkIfEmailExist() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.text)
          .get();
      if (res.docs.length == 0) {
        verifiyNumber();
      } else {
        RegisterAlertDialog.showEmailAlreadyExist();
      }
    } catch (e) {}
  }

  verifiyNumber() async {
    isVerifyingNumber(true);
    await auth.verifyPhoneNumber(
        // phoneNumber: "09367325510",
        phoneNumber: "+63${contact.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {});
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
          isVerifyingNumber(false);
        },
        codeSent: (String verificationID, int? resendToken) {
          verifIDReceived = verificationID;
          Get.to(() => OtpView());
          isVerifyingNumber(false);
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 60));
  }
}
