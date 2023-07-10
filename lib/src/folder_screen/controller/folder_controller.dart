import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dm/src/home_screen/controller/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../../home_screen/model/home_files_model.dart';

class FolderController extends GetxController {
  RxString parentID = ''.obs;

  RxString foldername = ''.obs;
  RxList<FilesModels> foldersList = <FilesModels>[].obs;
  RxList<FilesModels> folderFileList = <FilesModels>[].obs;
  RxList<FilesModels> folderFileList_masterList = <FilesModels>[].obs;

  RxBool isGridView = true.obs;
  Timer? debounce;

  RxBool isUploadingFile = false.obs;
  List<String> formats = [
    'png',
    'jpg',
    'svg',
    'jpeg',
    'gif',
    'docx',
    'csv',
    'pdf',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt'
  ];

  RxString fileName = ''.obs;
  RxString filePath = ''.obs;
  RxString fileType = ''.obs;
  UploadTask? uploadTask;

  @override
  void onInit() {
    parentID.value = Get.arguments['parentID'];
    foldername.value = Get.arguments['foldername'];

    getFolderFiles();
    foldersList.assignAll(Get.find<HomeController>().foldersList);
    super.onInit();
  }

  getFolderFiles() async {
    List data = [];

    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      var res = await FirebaseFirestore.instance
          .collection('filesandfolders')
          .where('parent', isEqualTo: parentID.value)
          .where('owner', isEqualTo: userDocumentReference)
          .get();
      var files = res.docs;

      for (var i = 0; i < files.length; i++) {
        Map obj = {
          "id": files[i].id,
          "name": files[i]['name'],
          "parent": files[i]['parent'],
          "type": files[i]['type'],
          "url": files[i]['url'],
          "datecreated": files[i]['datecreated'].toDate().toString(),
        };
        data.add(obj);
      }
      folderFileList
          .assignAll(await filesModelsFromJson(await jsonEncode(data)));
      folderFileList.sort((b, a) => a.datecreated.compareTo(b.datecreated));
      folderFileList_masterList.assignAll(folderFileList);
    } catch (e) {}
  }

  pickFilesInGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: formats,
      type: FileType.custom,
    );

    if (result != null) {
      filePath.value = result.files.single.path!;
      fileName.value = result.files.single.name;
      fileType.value = result.files.single.extension!;
    } else {
      // User canceled the picker
    }
  }

  uploadFile() async {
    isUploadingFile(true);
    try {
      String fileLink = '';
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));

      if (fileName != '') {
        Uint8List uint8list =
            Uint8List.fromList(File(filePath.value).readAsBytesSync());
        final ref = await FirebaseStorage.instance
            .ref()
            .child("files/${fileName.value}");
        uploadTask = ref.putData(uint8list);
        final snapshot = await uploadTask!.whenComplete(() {});
        fileLink = await snapshot.ref.getDownloadURL();
      }
      String type = '';
      if (fileType.value == 'png' ||
          fileType.value == 'jpg' ||
          fileType.value == 'svg' ||
          fileType.value == 'jpeg' ||
          fileType.value == 'gif') {
        type = 'image';
      } else {
        type = 'document';
      }
      await FirebaseFirestore.instance.collection('filesandfolders').add({
        "datecreated": DateTime.now(),
        "name": fileName.value,
        "owner": userDocumentReference,
        "parent": parentID.value,
        "type": type,
        "url": fileLink
      });
      Get.back();
      isUploadingFile(false);
      await getFolderFiles();
    } catch (e) {
      print("ERROR: $e");
    }
    isUploadingFile(false);
  }

  copyFiles(
      {required FilesModels filetocopy, required BuildContext context}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var i = 0; i < foldersList.length; i++) {
        if (foldersList[i].isSelected.value == true) {
          batch.set(
              await FirebaseFirestore.instance
                  .collection('filesandfolders')
                  .doc(),
              {
                "datecreated": DateTime.now(),
                "name": filetocopy.name,
                "owner": userDocumentReference,
                "parent": foldersList[i].id,
                "type": filetocopy.type,
                "url": filetocopy.url
              });
        }
      }
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Copied'),
      ));
      Get.back();
      await getFolderFiles();
    } on Exception catch (e) {
      print("ERROR: $e");
    }
  }

  moveFile({required String documentID, required BuildContext context}) async {
    try {
      for (var i = 0; i < foldersList.length; i++) {
        if (foldersList[i].isSelected.value == true) {
          await FirebaseFirestore.instance
              .collection('filesandfolders')
              .doc(documentID)
              .update({"parent": foldersList[i].id});
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Moved'),
      ));
      Get.back();
      await getFolderFiles();
    } catch (e) {}
  }

  deleteFile({
    required String documentID,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('filesandfolders')
          .doc(documentID)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Deleted'),
      ));
      await getFolderFiles();
    } catch (e) {}
  }

  downloadFile(
      {required String link,
      required int index,
      required BuildContext context,
      required String filename}) async {
    folderFileList[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          folderFileList[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) {
          folderFileList[index].isDownloading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('File Successfully downloaded'),
          ));
        },
        onDownloadError: (String error) {
          folderFileList[index].isDownloading.value = false;
          print("ERROR: $error");
        });
  }

  renameFile(
      {required String documentID,
      required BuildContext context,
      required String name}) async {
    try {
      await FirebaseFirestore.instance
          .collection('filesandfolders')
          .doc(documentID)
          .update({"name": name});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Renamed'),
      ));
      Get.back();
      await getFolderFiles();
    } catch (e) {}
  }

  shareFileToUsers(
      {required FilesModels filedDetails,
      required BuildContext context}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      WriteBatch batch = await FirebaseFirestore.instance.batch();
      for (var i = 0; i < Get.find<HomeController>().usersList.length; i++) {
        batch.set(
            await FirebaseFirestore.instance.collection('sharedfiles').doc(), {
          "datecreated": DateTime.now(),
          "name": filedDetails.name,
          "owner": userDocumentReference,
          "parent": "root",
          "sharedto": Get.find<HomeController>().usersList[i].id,
          "type": filedDetails.type,
          "url": filedDetails.url,
        });
      }
      await batch.commit();
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Shared Successfully'),
      ));
    } on Exception catch (e) {
      print(e);
    }
  }

  searchFiles({required String keyword}) async {
    folderFileList.clear();
    if (keyword != '') {
      for (var i = 0; i < folderFileList_masterList.length; i++) {
        if (folderFileList_masterList[i]
            .name
            .toLowerCase()
            .toString()
            .contains(keyword)) {
          folderFileList.add(folderFileList_masterList[i]);
        }
      }
    } else {
      folderFileList.assignAll(folderFileList_masterList);
    }
  }
}
