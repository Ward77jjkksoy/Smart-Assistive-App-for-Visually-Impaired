import 'package:flutter/material.dart';
import 'package:mashromz/espcontroller.dart';
import 'package:mashromz/firstpage.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mashromz/history_page.dart';
import 'package:mashromz/home.dart';
import 'package:mashromz/main_shell_page.dart';
import 'package:mashromz/role_shell_page.dart';
import 'package:mashromz/settingspage.dart';
import 'package:mashromz/tts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'espcontroller.dart';
import 'navigation.dart';

void main(dynamic DefaultFirebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // تهيئة Firebase
  await Get.putAsync(() => TtsService().init());
  // ignore: unused_local_variable
  final TtsService tts = Get.find<TtsService>();
  Get.put(EspController(), permanent: true);
  Get.put(EspController());

  await Hive.initFlutter();
  Get.put(TtsService());
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // إعداد الإشعارات المحلية
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  // const InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // Get.put(mycontroller());
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString("id");
  print("🆔 المستخدم الحالي: $id");

  await Hive.openBox('sensorData');
  runApp(MyApp(initialRoute: id == null ? "/firstpage" : "/MainShellPage"));
}

class AppServicesFirebaseMessaging {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> _backgroundHandler(RemoteMessage message) async {
    // await processAppStart();
    // processMessage(message);
  }

  Future<void> init() async {
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler); // Exception here
  }
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp(initialRoute: '');
  }
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  MyApp({required this.initialRoute});
  // // This widget is the root of your application.
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[300],
          titleTextStyle: TextStyle(
            color: Colors.orange,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.orange),
        ),
      ),

      // initialRoute: sharedPref.getString("id") != null ? "/SqlDb" : "/login",
      initialRoute: widget.initialRoute,

      // initialBinding: MyBinding(),
      // home: FirebaseAuth.instance.currentUser == null ? Login() : SqlDb(),
      // routes: {
      //   'Signup': (context) => Signup(),
      //   'login': (context) => Login(),
      //   'homepage': (context) => Homepage(),
      //   'addcategory': (context) => AddCategory(),
      //   'testone': (context) => TestOne()
      // },
      home: FirstPage(),
      getPages: [
        GetPage(name: "/", page: () => const FirstPage()),
        GetPage(name: "/main_shell_page", page: () => MainShellPage()),
        GetPage(name: "/role_shell_page", page: () => RoleShellPage()),
        GetPage(name: "/home", page: () => DashboardPage()),
        // GetPage(name: "/espcontroller", page: () =>  EspController()),
        GetPage(name: '/navigation', page: () => NavigationPage()),
        GetPage(name: "/settingspage", page: () => SettingsPage()),
        GetPage(name: "/history_page", page: () => HistoryPage()),
      ],
    );
  }
}
