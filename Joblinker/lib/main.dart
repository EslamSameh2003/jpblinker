import 'package:flutter/material.dart';
import 'package:joblinker/Auth_login.dart';
import 'package:joblinker/SignUp.dart';
import 'Login.dart';
import 'comp_home.dart';
import 'empoloyee_home.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';


//stl
//ctrl+ space show functions
// ctrl+ click lift details about widget
// Alt+enter wrap
/*
void main(){

  runApp( MyApp());
}
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //return MaterialApp( home: Text ('hello world'),);
    return MaterialApp(
      home:Signup(),

      // home: EmployeeProfile(),
      debugShowCheckedModeBanner:false,

    );


  }

}