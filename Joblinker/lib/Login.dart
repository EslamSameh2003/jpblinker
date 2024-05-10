import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'EmployeeProfile.dart';
import 'SignUp.dart';
import 'comp_home.dart';
import 'empoloyee_home.dart';


class Login extends StatelessWidget {

  var email_cont1=TextEditingController();
  var pass_cont1=TextEditingController();

  //////////////////////////////////////////////////////////////
  Future UserRegister2()async{
    FirebaseAuth.instance.signInWithEmailAndPassword
      (
      email: email_cont1.text.trim(),
      password: pass_cont1.text.trim(),
    );

  }


  ////////////////////////////////////////////////////////////
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
                  fontWeight: FontWeight.bold ,

                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField( // دي اللي بيتعمل ال input زرار
                controller: email_cont1,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted:( String value){
                  print(value);
                } ,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    // borderRadius: BorderRadius.circular(10.0),
                  ),
                  border:OutlineInputBorder(
                    borderSide:BorderSide(color: Colors.teal),
                  ),

                  labelText: "Email Address",
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon:Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ),

              ),
              SizedBox(
                height: 16.0,
              ),
           //////////////////
              TextFormField( // دي اللي بيتعمل ال inputbox
                controller: pass_cont1 ,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true, // بتخلي الكلام اللي هتكتبه مخفي
                onFieldSubmitted:( String value){
                  print(value);
                } ,
                decoration: InputDecoration(
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ) ,

                  border: OutlineInputBorder(),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.teal),
                  prefixIcon:Icon(
                    color:Colors.grey ,
                    Icons.lock,
                  ),
                  suffix: Icon(
                    Icons.remove_red_eye,
                  )
                ),

              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                color: Colors.teal,
                width: double.infinity,
                child: MaterialButton(
                    onPressed: (){
                      print(email_cont1.text);
                      print(pass_cont1.text);
                      UserRegister2();

                    },
                  child:Text
                    (
                    "login",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,

                    ),

                  ) ,

                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Text(
                    "if you don't have account ?",
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:(context)=> Signup()),);
                      },
                      child: Text(
                       "SignUp",
                       style: TextStyle(
                         fontSize: 16.0,
                         color: Colors.teal,
                       ),
                      ),
                  ),
                ],
              )
            ],


          ),
              ),
        ),
      ),

    );

  }

}
