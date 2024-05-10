import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joblinker/storage_cv.dart';
//import 'package:test1/storage_cv.dart';
// import 'package:test1/Screen_home.dart';
import 'Job_text_field.dart';

import 'empoloyee_home.dart';

class EmployeeProfile extends StatefulWidget {
  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values
    _nameController.text = '';
    _addressController.text = '';
    _phoneController.text = '';
    _emailController.text = '';
  }

  int _selectedIndexEmployeeProfile = 1;

  void _onItemTappedEmployeeProfile(int index) {
    if (_selectedIndexEmployeeProfile != index) {
      setState(() {
        _selectedIndexEmployeeProfile = index;
      });
      if (_selectedIndexEmployeeProfile == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployeeHome()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('profile.jpeg'),
              ),
              SizedBox(height: 50,),
              _buildProfileField('Name', _nameController, CupertinoIcons.person),
              SizedBox(height: 20,),
              _buildProfileField('Address', _addressController, CupertinoIcons.location),
              SizedBox(height: 20,),
              _buildProfileField('Phone', _phoneController, CupertinoIcons.phone),
              SizedBox(height: 20,),
              _buildProfileField('Email', _emailController, CupertinoIcons.mail),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing; // Toggle editing mode
                      // If currently in editing mode, save the changes
                      if (!_isEditing) {
                        // Save changes here
                        // For demonstration, let's just print the updated values
                        print('Name: ${_nameController.text}');
                        print('Address: ${_addressController.text}');
                        print('Phone: ${_phoneController.text}');
                        print('Email: ${_emailController.text}');
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(20, 50),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.teal.withOpacity(.8),),

                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCv()),
                    );

                  },
                  child: const Text("Storage CV ",
                    style:
                  TextStyle(
                    color: Colors.black,
                    fontSize: 20,

                  ),
                  )
              ),

            ],
          ),
        ),
      ),

      /////////////////////////Navigation Bar (myprofile & Home Screen)
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal[200],
        iconSize: 30.0,
        currentIndex: _selectedIndexEmployeeProfile,
        onTap: _onItemTappedEmployeeProfile,
        items: [
          BottomNavigationBarItem(label: "Employee Home",icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Employee Profile",icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _buildProfileField(String title, TextEditingController controller, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.teal.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: _isEditing
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(iconData),
          ),
        ),
      )
          : ListTile(
            title: Text(title),
             subtitle: Text(controller.text),
             leading: Icon(iconData),
      ),
    );
  }
}


