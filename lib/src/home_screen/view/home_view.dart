import 'dart:async';

import 'package:dm/services/colors_services.dart';
import 'package:dm/services/getstorage_services.dart';
import 'package:dm/src/home_screen/controller/home_controller.dart';
import 'package:dm/src/home_screen/widget/document_homewidget.dart';
import 'package:dm/src/home_screen/widget/folder_homewidget.dart';
import 'package:dm/src/home_screen/widget/image_homewidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../alertdialogs/home_alertdialogs.dart';
import '../appdrawer/home_appdrawer.dart';

class HomeScreenView extends GetView<HomeController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: HomeScreenAppDrawer.showAppDrawer(controller: controller),
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
                controller.searchFilesAndFolder(keyword: value);
                // Get.to(() => SearchView(), arguments: {"word": value});
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
          Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(Get.find<StorageServices>()
                            .storage
                            .read('image')))),
              ),
            );
          }),
          SizedBox(
            width: 5.w,
          )
        ],
      ),
      body: Obx(
        () => controller.filesList.length == 0
            ? Container(
                height: 100.h,
                width: 100.w,
                child: Center(
                  child: Text(
                    "You have no documents and folders at this moment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ),
              )
            : Container(
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
                          itemCount: controller.filesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 20.h,
                                width: 40.w,
                                child:
                                    controller.filesList[index].type == 'image'
                                        ? ImageWidget(
                                            index: index,
                                          )
                                        : controller.filesList[index].type ==
                                                'document'
                                            ? DocumentWidget(
                                                index: index,
                                              )
                                            : FolderWidget(index: index));
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.filesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 1.5.h),
                              child: Container(
                                  height: 20.h,
                                  width: 100.w,
                                  child: controller.filesList[index].type ==
                                          'image'
                                      ? ImageWidget(
                                          index: index,
                                        )
                                      : controller.filesList[index].type ==
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HomeAlertDialog.showCreateFolderOrFile(controller: controller);
        },
        backgroundColor: ColorServices.gold,
        child: Icon(Icons.add),
      ),
    );
  }
}
