import 'package:dm/services/colors_services.dart';
import 'package:dm/src/otp_screen/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OtpController());
    return Scaffold(
      body: Obx(
        () => controller.isVerifyingOTP.value == true
            ? Container(
                height: 100.h,
                width: 100.w,
                alignment: Alignment.center,
                child: Center(
                  child: SpinKitThreeBounce(
                    color: ColorServices.gold,
                    size: 40.sp,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verification Code",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 30.sp),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Please type the verification code",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
                  ),
                  Text(
                    "sent to +63${controller.contact}",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: OtpTextField(
                      numberOfFields: 6,
                      borderColor: Colors.grey,
                      disabledBorderColor: Colors.black,
                      enabledBorderColor: ColorServices.gold,
                      fillColor: Colors.grey,
                      showFieldAsBox: true,
                      focusedBorderColor: Colors.white,
                      onCodeChanged: (String code) {},

                      onSubmit: (String verificationCode) async {
                        PhoneAuthCredential phoneAuthCredential =
                            await PhoneAuthProvider.credential(
                                verificationId: controller.verifIDReceived,
                                smsCode: verificationCode);

                        controller.signInWithPhoneAuthCredential(
                            phoneAuthCredential, context);
                      }, // end onSubmit
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
