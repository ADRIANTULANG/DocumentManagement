import 'dart:async';

import 'package:dm/src/sharedfile_screen/controller/sharedfile_controller.dart';
import 'package:dm/src/sharedfile_screen/widget/document_homewidget.dart';
import 'package:dm/src/sharedfile_screen/widget/image_homewidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SharedFileView extends GetView<SharedFileController> {
  const SharedFileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SharedFileController());
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
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shared Files",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: Container(
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
                          itemCount: controller.sharedFilesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 20.h,
                                width: 40.w,
                                child: controller.sharedFilesList[index].type ==
                                        'image'
                                    ? ImageWidget(
                                        index: index,
                                      )
                                    : DocumentWidget(
                                        index: index,
                                      ));
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.sharedFilesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 1.5.h),
                              child: Container(
                                  height: 20.h,
                                  width: 100.w,
                                  child:
                                      controller.sharedFilesList[index].type ==
                                              'image'
                                          ? ImageWidget(
                                              index: index,
                                            )
                                          : DocumentWidget(
                                              index: index,
                                            )),
                            );
                          },
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
