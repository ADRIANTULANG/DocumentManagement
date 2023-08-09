import 'dart:convert';

import 'package:get/get.dart';

List<FilesModels> filesModelsFromJson(String str) => List<FilesModels>.from(
    json.decode(str).map((x) => FilesModels.fromJson(x)));

String filesModelsToJson(List<FilesModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FilesModels {
  String id;
  String name;
  String parent;
  String type;
  String url;
  DateTime datecreated;
  RxBool isSelected;
  RxBool isDownloading;
  RxDouble progress;
  String savePath;

  FilesModels({
    required this.id,
    required this.name,
    required this.parent,
    required this.type,
    required this.url,
    required this.datecreated,
    required this.isSelected,
    required this.progress,
    required this.isDownloading,
    required this.savePath,
  });

  factory FilesModels.fromJson(Map<String, dynamic> json) => FilesModels(
        id: json["id"],
        name: json["name"],
        parent: json["parent"],
        type: json["type"],
        url: json["url"],
        savePath: json["savePath"],
        isSelected: false.obs,
        isDownloading: false.obs,
        progress: 0.0.obs,
        datecreated: DateTime.parse(json["datecreated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "savePath": savePath,
        "isDownloading": isDownloading,
        "progress": progress,
        "isSelected": isSelected,
        "parent": parent,
        "type": type,
        "url": url,
        "datecreated": datecreated.toIso8601String(),
      };
}
