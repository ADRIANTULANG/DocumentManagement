import 'package:dm/src/folder_screen/controller/folder_controller.dart';
import 'package:dm/src/home_screen/controller/home_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../services/colors_services.dart';
import '../../home_screen/model/home_files_model.dart';

class FoldersFileAlertDialog {
  static showUploadFile({required FolderController controller}) async {
    controller.fileName.value = '';
    controller.filePath.value = '';
    controller.fileType.value = '';
    Get.dialog(AlertDialog(
        content: Obx(
      () => controller.isUploadingFile.value == true
          ? Container(
              height: 40.h,
              width: 100.w,
              child: Center(
                child: SpinKitThreeBounce(
                  color: ColorServices.gold,
                ),
              ),
            )
          : Container(
              height: 40.h,
              width: 100.w,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload File",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 3.5.h,
                  ),
                  InkWell(
                    onTap: () {
                      controller.pickFilesInGallery();
                    },
                    child: Container(
                      height: 25.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Obx(
                        () => controller.fileName.value == ""
                            ? Icon(Icons.file_upload_rounded)
                            : Container(
                                child: Image.asset(
                                    "assets/images/${controller.fileType.value}.png"),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Obx(() => Text(
                        controller.fileName.value,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp),
                      )),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: Colors.red),
                        ),
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      InkWell(
                        onTap: () {
                          controller.uploadFile();
                        },
                        child: Text(
                          "Upload",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    )));
  }

  static showFileDetails(
      {required FolderController controller, required FilesModels file}) async {
    Reference ref = await FirebaseStorage.instance.refFromURL(file.url);
    RxString name = file.name.obs;
    RxString filesize = ''.obs;
    RxString contenttype = ''.obs;
    RxString dateCreated = ''.obs;
    RxString timeCreated = ''.obs;

    ref.getMetadata().then((metadata) {
      filesize.value = metadata.size.toString();
      contenttype.value = metadata.contentType.toString();
      dateCreated.value = DateFormat('yMMMd').format(metadata.timeCreated!);
      timeCreated.value = DateFormat('jm').format(metadata.timeCreated!);
    }).catchError((error) {
      print("Error getting file metadata: $error");
    });
    Get.dialog(AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Done",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: ColorServices.gold),
            ))
      ],
      content: Container(
        height: 25.h,
        width: 100.w,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "File Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.black),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            Row(
              children: [
                Text("Name: "),
                Expanded(
                  child: Container(
                    width: 100.w,
                    child: Obx(() => Text(
                          name.value,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Text("Size: "),
                Obx(() => Text(filesize.value + " bytes"))
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Text("Content Type: "),
                Expanded(
                  child: Container(
                    width: 100.w,
                    child: Obx(() => Text(
                          contenttype.value,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Text("Date Created: "),
                Obx(() => Text(dateCreated.value))
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Text("Time Created: "),
                Obx(() => Text(timeCreated.value))
              ],
            ),
          ],
        ),
      ),
    ));
  }

  static showRenameFile(
      {required FolderController controller,
      required BuildContext context,
      required String defaultname,
      required String documentID}) async {
    TextEditingController name =
        TextEditingController(text: defaultname.split('.')[0]);
    Get.dialog(AlertDialog(
      content: Container(
        height: 20.h,
        width: 100.w,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rename File",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.black),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            Container(
              height: 7.h,
              width: 100.w,
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4)),
                    hintText: 'File Name'),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: Colors.red),
                  ),
                ),
                SizedBox(
                  width: 7.w,
                ),
                InkWell(
                  onTap: () {
                    controller.renameFile(
                        documentID: documentID,
                        name: name.text + "." + defaultname.split('.')[1],
                        context: context);
                  },
                  child: Text(
                    "Rename",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  static showShareFile(
      {required FolderController controller,
      required BuildContext context,
      required FilesModels file}) async {
    TextEditingController email = TextEditingController();
    Get.dialog(AlertDialog(
      content: Container(
        height: 40.h,
        width: 100.w,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Share File",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.black),
            ),
            SizedBox(
              height: 3.5.h,
            ),
            Container(
              height: 7.h,
              width: 100.w,
              child: TextField(
                controller: email,
                onChanged: (value) {
                  Get.find<HomeController>().searchUser(keyword: email.text);
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4)),
                    hintText: 'Search User'),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: Get.find<HomeController>().usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: .1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 9.h,
                                width: 9.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            Get.find<HomeController>()
                                                .usersList[index]
                                                .image))),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Text(
                                Get.find<HomeController>()
                                    .usersList[index]
                                    .email,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 9.sp),
                              ),
                            ],
                          ),
                          Obx(
                            () => Checkbox(
                                value: Get.find<HomeController>()
                                    .usersList[index]
                                    .isSelected
                                    .value,
                                onChanged: (value) {
                                  Get.find<HomeController>()
                                      .usersList[index]
                                      .isSelected
                                      .value = value!;
                                }),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: ElevatedButton(
                  child: Text("SHARE", style: TextStyle(fontSize: 18.sp)),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(ColorServices.gold),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.white)))),
                  onPressed: () {
                    controller.shareFileToUsers(
                        filedDetails: file, context: context);
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}
