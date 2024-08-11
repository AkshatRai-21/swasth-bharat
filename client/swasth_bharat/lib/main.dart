import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasth_bharat/common/widgets/bottom_bar.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/features/appointment/doctor_appointment_screen.dart';
import 'package:swasth_bharat/features/auth/screens/auth_screen.dart';
import 'package:swasth_bharat/firebase_options.dart';
import 'package:swasth_bharat/providers/user_provider.dart';
import 'package:swasth_bharat/routes.dart';
import 'package:http/http.dart' as http;

//idhar maine main me changes kre ha
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//for notification
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.getToken().then((value) {
    print("getToken:$value");
  });

  //if app is open
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print(message);
    print("oneMessageopened:$message");
    Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
        arguments: {"message": json.encode(message)});
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //if app is clossed or terminated
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    print(message);

    if (message != null) {
      Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
          arguments: {"message": json.encode(message)});
    }
  });

//for user
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('x-auth-token') ?? '';

  // Create the UserProvider instance
  UserProvider userProvider = UserProvider();

  if (token.isNotEmpty) {
    final tokenValidationResponse = await http.post(
      Uri.parse('$uri/userAuth/tokenIsValid'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    if (jsonDecode(tokenValidationResponse.body)) {
      final userResponse = await http.get(
        Uri.parse('$uri/userAuth/getUser'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (userResponse.statusCode == 200) {
        userProvider.setUser(userResponse.body);
      }
    }
  }
  //if a notification comes and we have to do sth in bakground silently without notifying the user
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => userProvider,
      ),
    ],
    child: const MyApp(),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message);
  await Firebase.initializeApp();
  print("_firebaseMessagingBackgroundHandler:$message");
}

// Run the app with the UserProvider instance

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return userProvider.user.token.isNotEmpty
              ? const BottomBar()
              : const AuthScreen();
        },
      ),
    );
  }
}
