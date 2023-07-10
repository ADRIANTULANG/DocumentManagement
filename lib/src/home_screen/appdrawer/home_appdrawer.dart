import 'package:dm/services/colors_services.dart';
import 'package:dm/src/sharedfile_screen/view/sharedfile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../profile_screen/view/profile_view.dart';
import '../alertdialogs/home_alertdialogs.dart';
import '../controller/home_controller.dart';

class HomeScreenAppDrawer {
  static showAppDrawer({required HomeController controller}) {
    return Drawer(
      backgroundColor: ColorServices.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Container(
              height: 15.h,
              width: 100.w,
              child: Image.asset(
                "assets/images/loginlogo.png",
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 3.h,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.to(() => ProfileView());
            },
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('Shared Files'),
            onTap: () {
              Get.to(() => SharedFileView());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () {
              HomeAlertDialog.showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }
}
