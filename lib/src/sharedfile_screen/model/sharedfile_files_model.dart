import 'dart:convert';

import 'package:get/get.dart';

List<SharedFiles> sharedFilesFromJson(String str) => List<SharedFiles>.from(
    json.decode(str).map((x) => SharedFiles.fromJson(x)));

String sharedFilesToJson(List<SharedFiles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SharedFiles {
  String id;
  String name;
  String parent;
  String type;
  String url;
  RxBool isDownloading;
  RxDouble progress;
  DateTime datecreated;

  SharedFiles({
    required this.id,
    required this.name,
    required this.parent,
    required this.type,
    required this.url,
    required this.datecreated,
    required this.isDownloading,
    required this.progress,
  });

  factory SharedFiles.fromJson(Map<String, dynamic> json) => SharedFiles(
        id: json["id"],
        name: json["name"],
        parent: json["parent"],
        type: json["type"],
        url: json["url"],
        isDownloading: false.obs,
        progress: 0.0.obs,
        datecreated: DateTime.parse(json["datecreated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parent": parent,
        "type": type,
        "url": url,
        "isDownloading": isDownloading,
        "progress": progress,
        "datecreated": datecreated.toIso8601String(),
      };
}
