import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'getstorage_services.dart';

class NotificationServices extends GetxService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token;

  @override
  Future<void> onInit() async {
    if (await checkNotificationPermission() == true) {
      await notificationSetup();
      await onBackgroundMessage();
      await onForegroundMessage();
    }
    ;

    super.onInit();
  }

  Future<void> notificationSetup() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'basic_channel_muted',
          channelName: 'Basic muted notifications ',
          channelDescription: 'Notification channel for muted basic tests',
          importance: NotificationImportance.High,
          playSound: false,
        )
      ],
    );
  }

  Future<void> onForegroundMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');

          // if (Get.find<StorageService>().storage.read("notificationSound") ==
          //     true) {
          //   AwesomeNotifications().createNotification(
          //     content: NotificationContent(
          //       id: Random().nextInt(9999),
          //       channelKey: 'basic_channel',
          //       title: '${message.notification!.title}',
          //       body: '${message.notification!.body}',
          //       notificationLayout: NotificationLayout.BigText,
          //     ),
          //   );
          // } else {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: Random().nextInt(9999),
              channelKey: 'basic_channel_muted',
              title: '${message.notification!.title}',
              body: '${message.notification!.body}',
              notificationLayout: NotificationLayout.BigText,
            ),
          );

          // }

          // call_unseen_messages();
        }
      },
    );
  }

  Future<bool> checkNotificationPermission() async {
    var res = await messaging.requestPermission();
    print("notification status: ${res.authorizationStatus}");
    if (res.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else {
      return false;
    }
    // if (Get.find<StorageService>().storage.read('token') == "") {
    //   await getToken();
    // }
  }

  // sendNotification({required String userToken}) async {
  //   print(userToken);
  //   var body = jsonEncode({
  //     "to":
  //         "fSw60xJBTW2Bhvksvp8aQ2:APA91bFtS5cuZoDGdlJD2-69OqyTo_8QM62INOk3Ep-B-04820LQkPIowmT416dVnYAxo6d89PILD1zWLjFS0gTeHpRjN_y3nn925uMmpqLjdmf_Ns3tWFnSpOYDTS_5WSQwc0ilfIJL",
  //     "notification": {
  //       "body": "Hi your order is Accepted",
  //       "title": "Food3ip",
  //       "subtitle": "",
  //     }
  //   });
  //   var e2epushnotif =
  //       await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //           headers: {
  //             "Authorization":
  //                 "key=AAAAFXgQldg:APA91bH0blj9KQykFmRZ1Pjub61SPwFyaq-YjvtH1vTvsOeNQ6PTWCYm5S7pOZIuB5zuc7hrFFYsRbuxEB8vF9N5nQoW9fZckjy4bwwltxf4ATPeBDH4L4VlZ1yyVBHF3OKr3yVZ_Ioy",
  //             "Content-Type": "application/json"
  //           },
  //           body: body);
  //   print("e2e notif: ${e2epushnotif.body}");
  // }

  Future<void> getToken() async {
    token = await messaging.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"))
        .update({"fcmToken": token});
    print('Generated device token: $token');
  }
}

Future<void> onBackgroundMessage() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');

    // if (Get.find<StorageService>().storage.read("notificationSound") ==
    //     true) {
    //   AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       id: Random().nextInt(9999),
    //       channelKey: 'basic_channel',
    //       title: '${message.notification!.title}',
    //       body: '${message.notification!.body}',
    //       notificationLayout: NotificationLayout.BigText,
    //     ),
    //   );
    // } else {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(9999),
        channelKey: 'basic_channel_muted',
        title: '${message.notification!.title}',
        body: '${message.notification!.body}',
        notificationLayout: NotificationLayout.BigText,
      ),
    );

    // }

    // call_unseen_messages();
  }
}
