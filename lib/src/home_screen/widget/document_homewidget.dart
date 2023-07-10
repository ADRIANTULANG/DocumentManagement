import 'package:dm/src/home_screen/widget/select_folder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../services/colors_services.dart';
import '../alertdialogs/home_alertdialogs.dart';
import '../controller/home_controller.dart';

class DocumentWidget extends GetView<HomeController> {
  const DocumentWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => controller.isGridView.value == true
            ? Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 17.h,
                        width: 100.w,
                        child: Image.asset(
                            "assets/images/${controller.filesList[index].name.split('.')[1]}.png"),
                      ),
                      Positioned(
                        child: Obx(
                          () => controller
                                      .filesList[index].isDownloading.value ==
                                  false
                              ? SizedBox()
                              : Obx(
                                  () => CircularPercentIndicator(
                                    radius: 8.w,
                                    lineWidth: 1.w,
                                    animation: true,
                                    percent: controller
                                        .filesList[index].progress.value,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: ColorServices.gold,
                                  ),
                                ),
                        ),
                      )
                    ],
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
                        PopupMenuButton(
                          onSelected: (value) {
                            if (value == "Copy") {
                              Get.to(() => SelectFolderView(
                                    action: "Copy",
                                    file: controller.filesList[index],
                                  ));
                            }
                            if (value == "Move") {
                              Get.to(() => SelectFolderView(
                                    action: "Move",
                                    file: controller.filesList[index],
                                  ));
                            }
                            if (value == "Delete") {
                              controller.deleteFile(
                                  documentID: controller.filesList[index].id,
                                  context: context);
                            }
                            if (value == "Rename") {
                              HomeAlertDialog.showRenameFile(
                                defaultname: controller.filesList[index].name,
                                controller: controller,
                                context: context,
                                documentID: controller.filesList[index].id,
                              );
                            }
                            if (value == "Details") {
                              HomeAlertDialog.showFileDetails(
                                  controller: controller,
                                  file: controller.filesList[index]);
                            }
                            if (value == "Download") {
                              controller.downloadFile(
                                  context: context,
                                  link: controller.filesList[index].url,
                                  index: index,
                                  filename: controller.filesList[index].name);
                            }
                            if (value == "Share") {
                              HomeAlertDialog.showShareFile(
                                  file: controller.filesList[index],
                                  controller: controller,
                                  context: context);
                            }
                          },
                          itemBuilder: (BuildContext bc) {
                            return [
                              PopupMenuItem(
                                child: Text("Copy"),
                                value: 'Copy',
                              ),
                              PopupMenuItem(
                                child: Text("Move"),
                                value: 'Move',
                              ),
                              PopupMenuItem(
                                child: Text("Rename"),
                                value: 'Rename',
                              ),
                              PopupMenuItem(
                                child: Text("Share"),
                                value: 'Share',
                              ),
                              PopupMenuItem(
                                child: Text("Delete"),
                                value: 'Delete',
                              ),
                              PopupMenuItem(
                                child: Text("Download"),
                                value: 'Download',
                              ),
                              PopupMenuItem(
                                child: Text("Details"),
                                value: 'Details',
                              )
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
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 17.h,
                          width: 40.w,
                          color: Colors.grey[100],
                          child: Image.asset(
                            "assets/images/${controller.filesList[index].name.split('.')[1]}.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          child: Obx(
                            () => controller
                                        .filesList[index].isDownloading.value ==
                                    false
                                ? SizedBox()
                                : Obx(
                                    () => CircularPercentIndicator(
                                      radius: 8.w,
                                      lineWidth: 1.w,
                                      animation: true,
                                      percent: controller
                                          .filesList[index].progress.value,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: ColorServices.gold,
                                    ),
                                  ),
                          ),
                        )
                      ],
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
                                if (value == "Copy") {
                                  Get.to(() => SelectFolderView(
                                        action: "Copy",
                                        file: controller.filesList[index],
                                      ));
                                }
                                if (value == "Move") {
                                  Get.to(() => SelectFolderView(
                                        action: "Move",
                                        file: controller.filesList[index],
                                      ));
                                }
                                if (value == "Delete") {
                                  controller.deleteFile(
                                      documentID:
                                          controller.filesList[index].id,
                                      context: context);
                                }
                                if (value == "Rename") {
                                  HomeAlertDialog.showRenameFile(
                                    defaultname:
                                        controller.filesList[index].name,
                                    controller: controller,
                                    context: context,
                                    documentID: controller.filesList[index].id,
                                  );
                                }
                                if (value == "Details") {
                                  HomeAlertDialog.showFileDetails(
                                      controller: controller,
                                      file: controller.filesList[index]);
                                }
                                if (value == "Download") {
                                  controller.downloadFile(
                                      context: context,
                                      link: controller.filesList[index].url,
                                      index: index,
                                      filename:
                                          controller.filesList[index].name);
                                }
                                if (value == "Share") {
                                  HomeAlertDialog.showShareFile(
                                      file: controller.filesList[index],
                                      controller: controller,
                                      context: context);
                                }
                              },
                              itemBuilder: (BuildContext bc) {
                                return [
                                  PopupMenuItem(
                                    child: Text("Copy"),
                                    value: 'Copy',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Move"),
                                    value: 'Move',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Rename"),
                                    value: 'Rename',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Share"),
                                    value: 'Share',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    value: 'Delete',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Download"),
                                    value: 'Download',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Details"),
                                    value: 'Details',
                                  )
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
    );
  }
}
