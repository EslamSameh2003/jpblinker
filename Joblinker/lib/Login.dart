import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EmployeeProfile.dart';
import 'SignUp.dart';
import 'comp_home.dart';
import 'empoloyee_home.dart';
import 'global_variables.dart'; // Import the global variables file

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    labelText: "Email Address",
                    labelStyle: TextStyle(color: Colors.teal),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: passController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.teal),
                    prefixIcon: Icon(
                      color: Colors.grey,
                      Icons.lock,
                    ),
                    suffix: Icon(
                      Icons.remove_red_eye,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  color: Colors.teal,
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        final UserCredential userCredential =
                        await _auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text,
                        );

                        // Check if user exists in 'company' collection
                        QuerySnapshot companySnapshot = await _firestore
                            .collection('company')
                            .where('email', isEqualTo: emailController.text)
                            .get();

                        // Check if user exists in 'employee' collection
                        QuerySnapshot employeeSnapshot = await _firestore
                            .collection('employee')
                            .where('email', isEqualTo: emailController.text)
                            .get();

                        if (companySnapshot.docs.isNotEmpty) {
                          var userDoc = companySnapshot.docs[0];
                          globalFirstName = userDoc['firstName'];
                          Navigator.pushReplacementNamed(context, 'companyHome');
                        } else if (employeeSnapshot.docs.isNotEmpty) {
                          var userDoc = employeeSnapshot.docs[0];
                          globalFirstName = userDoc['firstName'];
                          Navigator.pushReplacementNamed(context, 'employeeHome');
                        } else {
                          // Handle if user does not exist or is not in either collection
                        }
                      } catch (e) {
                        // Handle login errors
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Login Failed"),
                              content: Text("Invalid email or password."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Text("If you don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'signup');
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
