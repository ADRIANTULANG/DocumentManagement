import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InsideFolderImageViewer extends StatelessWidget {
  const InsideFolderImageViewer({super.key, required this.imageLink});
  final String imageLink;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth, image: NetworkImage(imageLink))),
    );
  }
}
