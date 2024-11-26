// import 'package:contact1313/user/user_pref.dart';
// import 'package:flutter/material.dart';
// import 'package:mysql_client/mysql_client.dart';
// import 'package:contact1313/api/api.dart';
// import 'model/user.dart';
// import 'my_app.dart';
//
//
// void main() async {
//   runApp(const MyApp());
// }
//
// Future<void> dbConnector() async{
//   // print("Connecting to mysql Server...");
//   // final conn = await MySQLConnection.createConnection(
//   //     host: "localhost", port: 80, userName: userName, password: password
//   // )
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'authentication/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: LoginPage(),
    );
  }
}