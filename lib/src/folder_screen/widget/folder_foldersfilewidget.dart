import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../controller/folder_controller.dart';

class FolderWidget extends GetView<FolderController> {
  const FolderWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => controller.isGridView.value == true
            ? Column(
                children: [
                  Container(
                    height: 17.h,
                    width: 100.w,
                    child: Icon(
                      Icons.folder,
                      color: Colors.grey,
                      size: 100.sp,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.folderFileList[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                              ),
                              Text(
                                DateFormat('yMMMd').format(controller
                                        .folderFileList[index].datecreated) +
                                    " " +
                                    DateFormat('jm').format(controller
                                        .folderFileList[index].datecreated),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 8.sp),
                              ),
                            ],
                          ),
                        )),
                        Container(
                          width: 7.w,
                          child: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ))
                ],
              )
            : Container(
                child: Row(
                  children: [
                    Container(
                      height: 17.h,
                      width: 40.w,
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.folder,
                        color: Colors.grey,
                        size: 100.sp,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                        child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  controller.folderFileList[index].name,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp),
                                ),
                                Text(
                                  DateFormat('yMMMd').format(controller
                                          .folderFileList[index].datecreated) +
                                      " " +
                                      DateFormat('jm').format(controller
                                          .folderFileList[index].datecreated),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 8.sp),
                                ),
                              ],
                            ),
                          )),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Container(
                              width: 7.w,
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
      ),
    );
  }
}
