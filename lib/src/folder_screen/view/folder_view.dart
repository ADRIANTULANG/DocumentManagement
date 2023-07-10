import 'dart:async';

import 'package:dm/src/folder_screen/alertdialog/foldersfiles_alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../services/colors_services.dart';
import '../../../services/getstorage_services.dart';
import '../controller/folder_controller.dart';
import '../widget/document_foldersfilewidget.dart';
import '../widget/folder_foldersfilewidget.dart';
import '../widget/image_foldersfilewidget.dart';

class FolderView extends GetView<FolderController> {
  const FolderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FolderController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leadingWidth: 25.w,
        leading: Row(
          children: [
            SizedBox(
              width: 5.w,
            ),
            InkWell(
                onTap: () {
                  controller.isGridView.value = false;
                },
                child: Icon(Icons.list)),
            SizedBox(
              width: 2.w,
            ),
            InkWell(
                onTap: () {
                  controller.isGridView.value = true;
                },
                child: Icon(Icons.grid_view))
          ],
        ),
        title: Container(
          height: 5.h,
          width: 100.w,
          child: TextField(
            onChanged: (value) {
              if (controller.debounce?.isActive ?? false)
                controller.debounce!.cancel();
              controller.debounce =
                  Timer(const Duration(milliseconds: 1000), () {
                controller.searchFiles(keyword: value);
                FocusScope.of(context).unfocus();
              });
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.only(left: 3.w),
                alignLabelWithHint: false,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Search'),
          ),
        ),
        actions: [
          Container(
            height: 10.h,
            width: 10.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        Get.find<StorageServices>().storage.read('image')))),
          ),
          SizedBox(
            width: 5.w,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5.w,
              right: 5.w,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Obx(
                () => Text(
                  controller.foldername.value,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.folderFileList.length == 0
                ? Expanded(
                    child: Container(
                    child: Center(
                      child: Text(
                        "You have no documents at this moment.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                  ))
                : Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
                      child: Obx(
                        () => controller.isGridView.value == true
                            ? GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.88,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 2.w,
                                        mainAxisSpacing: 1.h),
                                itemCount: controller.folderFileList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      height: 20.h,
                                      width: 40.w,
                                      child: controller
                                                  .folderFileList[index].type ==
                                              'image'
                                          ? ImageWidget(
                                              index: index,
                                            )
                                          : controller.folderFileList[index]
                                                      .type ==
                                                  'document'
                                              ? DocumentWidget(
                                                  index: index,
                                                )
                                              : FolderWidget(index: index));
                                },
                              )
                            : ListView.builder(
                                itemCount: controller.folderFileList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: Container(
                                        height: 20.h,
                                        width: 100.w,
                                        child: controller.folderFileList[index]
                                                    .type ==
                                                'image'
                                            ? ImageWidget(
                                                index: index,
                                              )
                                            : controller.folderFileList[index]
                                                        .type ==
                                                    'document'
                                                ? DocumentWidget(
                                                    index: index,
                                                  )
                                                : FolderWidget(index: index)),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FoldersFileAlertDialog.showUploadFile(controller: controller);
        },
        backgroundColor: ColorServices.gold,
        child: Icon(Icons.add),
      ),
    );
  }
}
