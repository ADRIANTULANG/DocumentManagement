import 'package:dm/src/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../services/colors_services.dart';
import '../model/home_files_model.dart';

class SelectFolderView extends GetView<HomeController> {
  const SelectFolderView({super.key, required this.action, required this.file});
  final String action;
  final FilesModels file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("$action file"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        child: ListView.builder(
          itemCount: controller.foldersList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 40.sp,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        controller.foldersList[index].name,
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  Obx(
                    () => Checkbox(
                        value: controller.foldersList[index].isSelected.value,
                        onChanged: (value) {
                          if (action == "Copy") {
                            controller.foldersList[index].isSelected.value =
                                value!;
                          } else if (action == "Move") {
                            for (var i = 0;
                                i < controller.foldersList.length;
                                i++) {
                              if (controller.foldersList[index].id ==
                                  controller.foldersList[i].id) {
                                controller.foldersList[i].isSelected.value =
                                    true;
                              } else {
                                controller.foldersList[i].isSelected.value =
                                    false;
                              }
                            }
                          }
                        }),
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 8.h,
        width: 100.w,
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 1.h),
        child: SizedBox(
          width: 100.w,
          height: 7.h,
          child: ElevatedButton(
              child: Text(action, style: TextStyle(fontSize: 18.sp)),
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
                if (action == "Copy") {
                  controller.copyFiles(filetocopy: file, context: context);
                }
                if (action == "Move") {
                  controller.moveFile(documentID: file.id, context: context);
                }
              }),
        ),
      ),
    );
  }
}
