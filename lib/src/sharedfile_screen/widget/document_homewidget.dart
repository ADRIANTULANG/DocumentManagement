import 'package:dm/src/sharedfile_screen/alertdialog/sharedfiles_alertdialog.dart';
import 'package:dm/src/sharedfile_screen/controller/sharedfile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../services/colors_services.dart';

class DocumentWidget extends GetView<SharedFileController> {
  const DocumentWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.openFile(
            index: index,
            link: controller.sharedFilesList[index].url,
            path: controller.sharedFilesList[index].savePath,
            documentID: controller.sharedFilesList[index].id,
            context: context,
            filename: controller.sharedFilesList[index].name);
      },
      child: Container(
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
                              "assets/images/${controller.sharedFilesList[index].name.split('.').last}.png"),
                        ),
                        Positioned(
                          child: Obx(
                            () => controller.sharedFilesList[index]
                                        .isDownloading.value ==
                                    false
                                ? SizedBox()
                                : Obx(
                                    () => CircularPercentIndicator(
                                      radius: 8.w,
                                      lineWidth: 1.w,
                                      animation: true,
                                      percent: controller.sharedFilesList[index]
                                          .progress.value,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
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
                                  controller.sharedFilesList[index].name,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp),
                                ),
                                Text(
                                  DateFormat('yMMMd').format(controller
                                          .sharedFilesList[index].datecreated) +
                                      " " +
                                      DateFormat('jm').format(controller
                                          .sharedFilesList[index].datecreated),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 8.sp),
                                ),
                              ],
                            ),
                          )),
                          PopupMenuButton(
                            onSelected: (value) {
                              if (value == "Delete") {
                                controller.deleteFile(
                                    documentID:
                                        controller.sharedFilesList[index].id,
                                    context: context);
                              }

                              if (value == "Details") {
                                SharedFilesAlertDialog.showFileDetails(
                                    controller: controller,
                                    file: controller.sharedFilesList[index]);
                              }
                              if (value == "Download") {
                                controller.downloadFile(
                                    context: context,
                                    link: controller.sharedFilesList[index].url,
                                    index: index,
                                    filename:
                                        controller.sharedFilesList[index].name);
                              }
                            },
                            itemBuilder: (BuildContext bc) {
                              return [
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
                              "assets/images/${controller.sharedFilesList[index].name.split('.').last}.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            child: Obx(
                              () => controller.sharedFilesList[index]
                                          .isDownloading.value ==
                                      false
                                  ? SizedBox()
                                  : Obx(
                                      () => CircularPercentIndicator(
                                        radius: 8.w,
                                        lineWidth: 1.w,
                                        animation: true,
                                        percent: controller
                                            .sharedFilesList[index]
                                            .progress
                                            .value,
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
                                    controller.sharedFilesList[index].name,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp),
                                  ),
                                  Text(
                                    DateFormat('yMMMd').format(controller
                                            .sharedFilesList[index]
                                            .datecreated) +
                                        " " +
                                        DateFormat('jm').format(controller
                                            .sharedFilesList[index]
                                            .datecreated),
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
                                  if (value == "Delete") {
                                    controller.deleteFile(
                                        documentID: controller
                                            .sharedFilesList[index].id,
                                        context: context);
                                  }

                                  if (value == "Details") {
                                    SharedFilesAlertDialog.showFileDetails(
                                        controller: controller,
                                        file:
                                            controller.sharedFilesList[index]);
                                  }
                                  if (value == "Download") {
                                    controller.downloadFile(
                                        context: context,
                                        link: controller
                                            .sharedFilesList[index].url,
                                        index: index,
                                        filename: controller
                                            .sharedFilesList[index].name);
                                  }
                                },
                                itemBuilder: (BuildContext bc) {
                                  return [
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
      ),
    );
  }
}
