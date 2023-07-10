import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../services/colors_services.dart';
import '../controller/sharedfile_controller.dart';
import '../model/sharedfile_files_model.dart';
import 'package:intl/intl.dart';

class SharedFilesAlertDialog {
  static showFileDetails(
      {required SharedFileController controller,
      required SharedFiles file}) async {
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
}
