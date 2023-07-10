import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../folder_screen/view/folder_view.dart';
import '../alertdialogs/home_alertdialogs.dart';
import '../controller/home_controller.dart';

class FolderWidget extends GetView<HomeController> {
  const FolderWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => FolderView(), arguments: {
          'parentID': controller.filesList[index].id,
          "foldername": controller.filesList[index].name
        });
      },
      child: Container(
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
                                  controller.filesList[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp),
                                ),
                                Text(
                                  DateFormat('yMMMd').format(controller
                                          .filesList[index].datecreated) +
                                      " " +
                                      DateFormat('jm').format(controller
                                          .filesList[index].datecreated),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 8.sp),
                                ),
                              ],
                            ),
                          )),
                          PopupMenuButton(
                            onSelected: (value) {
                              if (value == "Duplicate") {
                                controller.duplicateFolder(
                                    documentID: controller.filesList[index].id,
                                    context: context,
                                    folderDetails: controller.filesList[index]);
                              }
                              if (value == "Delete") {
                                controller.deleteFileAndFolder(
                                    documentID: controller.filesList[index].id,
                                    context: context);
                              }
                              if (value == "Rename") {
                                HomeAlertDialog.showRenameFolder(
                                  defaultname: controller.filesList[index].name,
                                  controller: controller,
                                  context: context,
                                  documentID: controller.filesList[index].id,
                                );
                              }
                            },
                            itemBuilder: (BuildContext bc) {
                              return [
                                PopupMenuItem(
                                  child: Text("Duplicate"),
                                  value: 'Duplicate',
                                ),
                                PopupMenuItem(
                                  child: Text("Rename"),
                                  value: 'Rename',
                                ),
                                PopupMenuItem(
                                  child: Text("Delete"),
                                  value: 'Delete',
                                ),
                              ];
                            },
                            child: Container(
                              width: 7.w,
                              child: Icon(Icons.more_vert),
                            ),
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
                                    controller.filesList[index].name,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp),
                                  ),
                                  Text(
                                    DateFormat('yMMMd').format(controller
                                            .filesList[index].datecreated) +
                                        " " +
                                        DateFormat('jm').format(controller
                                            .filesList[index].datecreated),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 8.sp),
                                  ),
                                ],
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == "Duplicate") {
                                    controller.duplicateFolder(
                                        documentID:
                                            controller.filesList[index].id,
                                        context: context,
                                        folderDetails:
                                            controller.filesList[index]);
                                  }
                                  if (value == "Delete") {
                                    controller.deleteFileAndFolder(
                                        documentID:
                                            controller.filesList[index].id,
                                        context: context);
                                  }
                                  if (value == "Rename") {
                                    HomeAlertDialog.showRenameFolder(
                                      defaultname:
                                          controller.filesList[index].name,
                                      controller: controller,
                                      context: context,
                                      documentID:
                                          controller.filesList[index].id,
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext bc) {
                                  return [
                                    PopupMenuItem(
                                      child: Text("Duplicate"),
                                      value: 'Duplicate',
                                    ),
                                    PopupMenuItem(
                                      child: Text("Rename"),
                                      value: 'Rename',
                                    ),
                                    PopupMenuItem(
                                      child: Text("Delete"),
                                      value: 'Delete',
                                    ),
                                  ];
                                },
                                child: Container(
                                  width: 7.w,
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
