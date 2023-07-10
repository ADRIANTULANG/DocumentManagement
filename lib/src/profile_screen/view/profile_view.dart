import 'package:dm/services/colors_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    controller.getImage();
                  },
                  child: Obx(
                    () => controller.filename.value == ''
                        ? Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        controller.imageLink.value))),
                          )
                        : Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        FileImage(controller.picked_image!))),
                          ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Account Details",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "First Name",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: TextField(
                    controller: controller.firstname,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Last Name",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: TextField(
                    controller: controller.lastname,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Contact no.",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: TextField(
                    controller: controller.contact,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  height: 1.5.h,
                  width: 100.w,
                  color: Colors.grey[200],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Credentials",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Username",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: TextField(
                    controller: controller.email,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    "Password",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 7.h,
                  width: 100.w,
                  child: TextField(
                    controller: controller.password,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.isUpdating.value == true
            ? Container(
                padding: EdgeInsets.only(
                    left: 5.w, right: 5.w, top: 2.h, bottom: 1.h),
                height: 8.h,
                width: 100.w,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey))),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: ColorServices.gold),
                    alignment: Alignment.center,
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 25.sp,
                    )),
              )
            : Container(
                padding: EdgeInsets.only(
                    left: 5.w, right: 5.w, top: 2.h, bottom: 1.h),
                height: 8.h,
                width: 100.w,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey))),
                child: InkWell(
                  onTap: () {
                    controller.updateAccount();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: ColorServices.gold),
                    alignment: Alignment.center,
                    child: Text(
                      "Update",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
