import 'package:dm/src/register_screen/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../services/colors_services.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegistrationController());
    return Scaffold(
      body: Obx(
        () => controller.isVerifyingNumber.value == true
            ? Center(
                child: SpinKitThreeBounce(
                  color: ColorServices.gold,
                  size: 40.sp,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: ColorServices.white,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage("assets/images/loginlogo.png"))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "User Info",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 7.h,
                            width: 42.w,
                            child: TextField(
                              controller: controller.firstname,
                              obscureText: false,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.only(left: 3.w),
                                  alignLabelWithHint: false,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  hintText: 'First name'),
                            ),
                          ),
                          Container(
                            height: 7.h,
                            width: 42.w,
                            child: TextField(
                              controller: controller.lastname,
                              obscureText: false,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.only(left: 3.w),
                                  alignLabelWithHint: false,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  hintText: 'Last name'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      height: 7.h,
                      width: 100.w,
                      child: TextField(
                        controller: controller.email,
                        obscureText: false,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Email'),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      height: 7.h,
                      width: 100.w,
                      child: TextField(
                        controller: controller.password,
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Password'),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Contact Info",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      height: 7.h,
                      width: 100.w,
                      child: TextField(
                        controller: controller.contact,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (controller.contact.text.length == 0) {
                          } else {
                            if (controller.contact.text[0] != "9" ||
                                controller.contact.text.length > 10) {
                              controller.contact.clear();
                            } else {}
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Contact no.'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Obx(
        () => controller.isVerifyingNumber.value == true
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
                child: SizedBox(
                  width: 100.w,
                  height: 7.h,
                  child: ElevatedButton(
                      child: Text("NEXT", style: TextStyle(fontSize: 18.sp)),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorServices.gold),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () {
                        if (controller.email.text.isEmpty ||
                            controller.password.text.isEmpty ||
                            controller.firstname.text.isEmpty ||
                            controller.lastname.text.isEmpty ||
                            controller.contact.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Empty field'),
                          ));
                        } else if (controller.email.text.isEmail == false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid Email'),
                          ));
                        } else if (controller.contact.text.length != 10) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid Contact no'),
                          ));
                        } else {
                          controller.checkIfEmailExist();
                        }
                      }),
                ),
              ),
      ),
    );
  }
}
