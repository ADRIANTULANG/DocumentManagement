import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dm/services/getstorage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../login_screen/view/login_view.dart';
import '../model/home_files_model.dart';
import '../model/home_users_model.dart';

class HomeController extends GetxController {
  Timer? debounce;
  RxList<FilesModels> filesList = <FilesModels>[].obs;
  RxList<FilesModels> filesList_masterList = <FilesModels>[].obs;
  RxList<FilesModels> foldersList = <FilesModels>[].obs;
  RxList<UsersModel> usersList = <UsersModel>[].obs;
  RxList<UsersModel> usersListMasterList = <UsersModel>[].obs;

  RxBool isCreatingFolder = false.obs;
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

  RxBool isGridView = true.obs;

  @override
  void onInit() {
    getFiles();
    getUsers();
    super.onInit();
  }

  getFiles() async {
    try {
      List data = [];
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      var res = await FirebaseFirestore.instance
          .collection('filesandfolders')
          .where('owner', isEqualTo: userDocumentReference)
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
          "datecreated": files[i]['datecreated'].toDate().toString(),
        };
        data.add(obj);
      }
      // print(jsonEncode(data));
      filesList.assignAll(await filesModelsFromJson(await jsonEncode(data)));
      filesList.sort((b, a) => a.datecreated.compareTo(b.datecreated));
      filesList_masterList.assignAll(filesList);
      getFolders();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  getFolders() async {
    foldersList.clear();
    foldersList.add(FilesModels(
        isDownloading: false.obs,
        progress: 0.0.obs,
        datecreated: DateTime.now(),
        id: "root",
        name: "root",
        parent: "root",
        type: 'folder',
        isSelected: false.obs,
        url: ""));
    for (var i = 0; i < filesList.length; i++) {
      if (filesList[i].type == 'folder') {
        foldersList.add(filesList[i]);
      }
    }
  }

  createFolder({required String name}) async {
    isCreatingFolder(true);
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      await FirebaseFirestore.instance.collection('filesandfolders').add({
        "datecreated": DateTime.now(),
        "name": name,
        "owner": userDocumentReference,
        "parent": "root",
        "type": "folder",
        "url": ""
      });
      await getFiles();
      Get.back();
      isCreatingFolder(false);
    } catch (e) {}
    isCreatingFolder(false);
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
        "parent": "root",
        "type": type,
        "url": fileLink
      });
      Get.back();
      isUploadingFile(false);
      await getFiles();
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
      await getFiles();
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
      await getFiles();
    } catch (e) {}
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
      await getFiles();
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
      await getFiles();
    } catch (e) {}
  }

  downloadFile(
      {required String link,
      required int index,
      required BuildContext context,
      required String filename}) async {
    filesList[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          filesList[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) {
          filesList[index].isDownloading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('File Successfully downloaded'),
          ));
        },
        onDownloadError: (String error) {
          filesList[index].isDownloading.value = false;
          print("ERROR: $error");
        });
  }

  duplicateFolder(
      {required String documentID,
      required BuildContext context,
      required FilesModels folderDetails}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      var res = await FirebaseFirestore.instance
          .collection('filesandfolders')
          .where('parent', isEqualTo: documentID)
          .where('owner', isEqualTo: userDocumentReference)
          .get();
      var duplicateFolder =
          await FirebaseFirestore.instance.collection('filesandfolders').add({
        "datecreated": DateTime.now(),
        "name": folderDetails.name,
        "owner": userDocumentReference,
        "parent": "root",
        "type": folderDetails.type,
        "url": ""
      });
      var files_inside_the_folder = await res.docs;
      WriteBatch batch = await FirebaseFirestore.instance.batch();
      for (var i = 0; i < files_inside_the_folder.length; i++) {
        batch.set(
            await FirebaseFirestore.instance
                .collection('filesandfolders')
                .doc(),
            {
              "datecreated": DateTime.now(),
              "name": files_inside_the_folder[i]['name'],
              "owner": userDocumentReference,
              "parent": duplicateFolder.id,
              "type": files_inside_the_folder[i]['type'],
              "url": files_inside_the_folder[i]['url'],
            });
      }
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Folder Duplicated'),
      ));
      await getFiles();
    } on Exception catch (e) {
      print(e);
    }
  }

  deleteFileAndFolder({
    required String documentID,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('filesandfolders')
          .doc(documentID)
          .delete();
      final filesFoldersBatchRef = await FirebaseFirestore.instance
          .collection('filesandfolders')
          .where("parent", isEqualTo: documentID)
          .get();
      WriteBatch filesFoldersBatch = FirebaseFirestore.instance.batch();
      for (final files in filesFoldersBatchRef.docs) {
        var filesFolderDocumentReference = await FirebaseFirestore.instance
            .collection('filesandfolders')
            .doc(files.id);
        filesFoldersBatch.delete(filesFolderDocumentReference);
      }
      await filesFoldersBatch.commit();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Folder Deleted Deleted'),
      ));
      await getFiles();
    } catch (e) {}
  }

  getUsers() async {
    try {
      List data = [];
      var res = await FirebaseFirestore.instance.collection('users').get();
      var users = res.docs;
      for (var i = 0; i < users.length; i++) {
        var profileImage = users[i]['image'];
        if (profileImage == '') {
          profileImage =
              'https://firebasestorage.googleapis.com/v0/b/documentmanagement-ad3ca.appspot.com/o/loginlogo.png?alt=media&token=97a8696c-fd0c-453f-843e-548c2c3c3491';
        }
        Map obj = {
          "id": users[i].id,
          "firstname": users[i]['firstname'],
          "lastname": users[i]['lastname'],
          "email": users[i]['email'],
          "contactno": users[i]['contactno'],
          "image": profileImage,
          "fcmToken": users[i]['fcmToken'],
        };
        data.add(obj);
      }
      var jsonEncodedData = await jsonEncode(data);
      usersList.assignAll(await usersModelFromJson(jsonEncodedData));
      usersList.removeWhere((element) =>
          element.id == Get.find<StorageServices>().storage.read('id'));
      usersListMasterList.assignAll(usersList);
    } catch (e) {}
  }

  searchUser({required String keyword}) async {
    usersList.clear();
    if (keyword != "") {
      for (var i = 0; i < usersListMasterList.length; i++) {
        if (usersListMasterList[i]
            .email
            .toLowerCase()
            .toString()
            .contains(keyword)) {
          usersList.add(usersListMasterList[i]);
        }
      }
    } else {
      usersList.assignAll(usersListMasterList);
    }
  }

  shareFileToUsers(
      {required FilesModels filedDetails,
      required BuildContext context}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      WriteBatch batch = await FirebaseFirestore.instance.batch();
      for (var i = 0; i < usersList.length; i++) {
        if (usersList[i].isSelected.value == true) {
          batch.set(
              await FirebaseFirestore.instance.collection('sharedfiles').doc(),
              {
                "datecreated": DateTime.now(),
                "name": filedDetails.name,
                "owner": userDocumentReference,
                "parent": "root",
                "sharedto": usersList[i].id,
                "type": filedDetails.type,
                "url": filedDetails.url,
              });
        }
      }
      await batch.commit();
      for (var i = 0; i < usersList.length; i++) {
        if (usersList[i].isSelected.value == true &&
            usersList[i].fcmToken != "") {
          sendNotification(
              userToken: usersList[i].fcmToken,
              message:
                  "${Get.find<StorageServices>().storage.read('firstname')} shared some files with you",
              title: "Shared files",
              subtitle: "");
        }
      }
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File Shared Successfully'),
      ));
    } on Exception catch (e) {
      print(e);
    }
  }

  searchFilesAndFolder({required String keyword}) async {
    filesList.clear();
    if (keyword != '') {
      for (var i = 0; i < filesList_masterList.length; i++) {
        if (filesList_masterList[i]
            .name
            .toLowerCase()
            .toString()
            .contains(keyword)) {
          filesList.add(filesList_masterList[i]);
        }
      }
    } else {
      filesList.assignAll(filesList_masterList);
    }
  }

  logout() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read('id'))
        .update({"deviceID": "", "deviceName": ""});
    Get.back();
    Get.find<StorageServices>().removeStorageCredentials();
    Get.offAll(() => LoginScreenView());
  }

  sendNotification(
      {required String userToken,
      required String message,
      required String title,
      required String subtitle}) async {
    print(userToken);
    var body = jsonEncode({
      "to": "$userToken",
      "notification": {
        "body": message,
        "title": title,
        "subtitle": subtitle,
      }
    });
    var pushNotif =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              "Authorization":
                  "key=AAAAf4rb1HU:APA91bFL3xmTcRfpC2G1bzgPpyuGjTHnH1u8QlhqXX7VccNJ6kxt2l5YZBiZfQqOcD0v75pctu444C87x34TrXGxLOaezfHK2RWcUEOJTGTCPdYdCHvFsNg0tUmIapYNPFaElM2-2qWl",
              "Content-Type": "application/json"
            },
            body: body);
    print("push notif: ${pushNotif.body}");
  }
}
