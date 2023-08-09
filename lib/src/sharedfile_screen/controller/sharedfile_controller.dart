import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../../services/getstorage_services.dart';
import '../model/sharedfile_files_model.dart';

class SharedFileController extends GetxController {
  Timer? debounce;
  RxList<SharedFiles> sharedFilesList = <SharedFiles>[].obs;
  RxList<SharedFiles> sharedFilesList_masterList = <SharedFiles>[].obs;

  RxBool isGridView = true.obs;
  @override
  void onInit() {
    getSharedFiles();
    super.onInit();
  }

  getSharedFiles() async {
    try {
      List data = [];
      // var userDocumentReference = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(Get.find<StorageServices>().storage.read('id'));
      var res = await FirebaseFirestore.instance
          .collection('sharedfiles')
          .where('sharedto',
              isEqualTo: Get.find<StorageServices>().storage.read('id'))
          .where('parent', isEqualTo: 'root')
          .get();
      var files = res.docs;
      for (var i = 0; i < files.length; i++) {
        Map obj = {
          "id": files[i].id,
          "name": files[i]['name'],
          "parent": files[i]['parent'],
          "type": files[i]['type'],
          "url": files[i]['url'],
          "savePath": files[i].data().containsKey('savePath') == true
              ? files[i]['savePath']
              : "",
          "datecreated": files[i]['datecreated'].toDate().toString(),
        };
        data.add(obj);
      }
      print(jsonEncode(data));
      sharedFilesList
          .assignAll(await sharedFilesFromJson(await jsonEncode(data)));
      sharedFilesList.sort((b, a) => a.datecreated.compareTo(b.datecreated));
      sharedFilesList_masterList.assignAll(sharedFilesList);
      // getFolders();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  deleteFile({
    required String documentID,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('sharedfiles')
          .doc(documentID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Deleted'),
      ));
      await getSharedFiles();
    } catch (e) {}
  }

  downloadFile(
      {required String link,
      required int index,
      required BuildContext context,
      required String filename}) async {
    sharedFilesList[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          sharedFilesList[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) {
          sharedFilesList[index].isDownloading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('File Successfully downloaded'),
          ));
        },
        onDownloadError: (String error) {
          sharedFilesList[index].isDownloading.value = false;
          print("ERROR: $error");
        });
  }

  searchFiles({required String keyword}) async {
    sharedFilesList.clear();
    if (keyword != '') {
      for (var i = 0; i < sharedFilesList_masterList.length; i++) {
        if (sharedFilesList_masterList[i]
            .name
            .toLowerCase()
            .toString()
            .contains(keyword)) {
          sharedFilesList.add(sharedFilesList_masterList[i]);
        }
      }
    } else {
      sharedFilesList.assignAll(sharedFilesList_masterList);
    }
  }

  openFile(
      {required String link,
      required String path,
      required String documentID,
      required int index,
      required BuildContext context,
      required String filename}) async {
    File file = File(path);
    var isExist = await file.exists();
    if (isExist == true) {
      OpenFile.open(path);
    } else {
      FileDownloader.downloadFile(
          url: link,
          name: filename,
          onProgress: (fileName, progress) {},
          onDownloadCompleted: (String path) async {
            log(path);
            sharedFilesList[index].savePath = path;
            await FirebaseFirestore.instance
                .collection('sharedfiles')
                .doc(documentID)
                .update({"savePath": path});
            OpenFile.open(path);
          },
          onDownloadError: (String error) {
            print("ERROR: $error");
          });
    }
  }
}
