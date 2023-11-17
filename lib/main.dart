import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gocabs_live/Screens/homescreen.dart';
import 'package:gocabs_live/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

late SharedPreferences prefs;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging fMessaging = FirebaseMessaging.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  _getFirebaseMessagingToken();
  await postData();
  runApp(const MyApp());
}

Future<void> postData() async {
  var url = 'https://13gocabs.com.au/api/Hdl_UpdateToken.ashx';
  var response = await http.post(Uri.parse(url), body: {
    'token': prefs.getString('token'),
  });

  if (response.statusCode == 200) {
  } else {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          primaryColor: schemecolor,
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: schemecolor,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: schemecolor,
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: schemecolor, onPrimary: Colors.white),
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: schemecolor,
          ),
          scaffoldBackgroundColor: bgcolor,
          fontFamily: GoogleFonts.outfit().fontFamily),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyTabs(),
    );
  }
}

Future<void> _getFirebaseMessagingToken() async {
  await fMessaging.requestPermission();

  await fMessaging.getToken().then((t) {
    if (t != null) {
      prefs.setString('token', t);
      print('Push Token: $t');
    }
  });
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  var adnroidinit = AndroidInitializationSettings('@drawable/cart');
  var initsetting = InitializationSettings(android: adnroidinit);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initsetting);
  var androiddetails = AndroidNotificationDetails('gocab', 'gocab', 'gocab',
      importance: Importance.high, priority: Priority.high);
  var generalnotify = NotificationDetails(android: androiddetails);

  // for handling foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.notification!.title}');
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          generalnotify);
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}
