import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joblinker/Login.dart';
import 'package:joblinker/empoloyee_home.dart';


class Auth_login extends StatelessWidget {
  const Auth_login({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator if the authentication state is still loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if there is an error with the authentication stream
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Check if the user is logged in
            final loggedIn = snapshot.hasData;
            return loggedIn ? EmployeeHome() : Login();
          }
        },
      ),
    );
  }
}

