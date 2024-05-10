
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {

  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {

  var email_cont = TextEditingController();
  var pass_cont = TextEditingController();
  var name_cont = TextEditingController();
  var _userType;


//////////////////////////// User Register in firebase ////////////////////

  Future<void> UserRegister() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email_cont.text.trim(),
        password: pass_cont.text.trim(),
      );

      // Add user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': name_cont.text.trim(),
        'userType': _userType,
      });

      // Navigate to appropriate home screen based on user type
      if (_userType == 'company') {
        Navigator.pushReplacementNamed(context, '/companyHome');
      } else if (_userType == 'employee') {
        Navigator.pushReplacementNamed(context, '/employeeHome');
      }
    } catch (e) {
      // Handle sign-up errors
      print('Error registering user: $e');
      // You can show a snackbar or display an error message to the user
    }
  }




///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white, leading: GestureDetector(
          onTap: (){
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
            },
          child: Icon(Icons.arrow_back_sharp,color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(

                  "SignUP",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold ,

                  ),
                ),

                SizedBox(
                  height: 16.0,
                ),
                ///////////////// name   ///////////////
                TextFormField(
                  controller: name_cont,
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (String value) {
                    print(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)
                    ),
                    border: OutlineInputBorder(),
                    labelText: "User Name",
                    labelStyle: TextStyle(color: Colors.teal),

                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ////////////////// Email/////////////
                TextFormField(
                  controller: email_cont,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String value) {
                    print(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)
                    ),
                    border: OutlineInputBorder(),
                    labelText: "EmailAddress",
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
                ////////////////// pass ////////////////
                TextFormField(
                  controller: pass_cont,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: false,
                  onFieldSubmitted: (String value) {
                    print(value);
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.teal),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffix: Icon(
                      Icons.remove_red_eye,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ///////////////////// option ///////////////////
                Text(
                  'Please select your user type:',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _userType = 'company';
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.business,
                              size: 50.0,
                              color: _userType == 'company'
                                  ? Colors.teal[200]
                                  : Colors.grey,
                            ),
                            Text(
                              'Company',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _userType == 'company'
                                    ? Colors.teal[200]
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _userType = 'employee';
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              size: 50.0,
                              color: _userType == 'employee'
                                  ? Colors.teal[200]
                                  : Colors.grey,
                            ),
                            Text(
                              'Employee',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _userType == 'employee'
                                    ? Colors.teal[200]
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.0),

                /////////////////////////// Register button ////////////////////
                Container(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () {

                      UserRegister();


                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                      )
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
