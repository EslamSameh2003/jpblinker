import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Job_text_field.dart';
import 'comp_home.dart';
import 'global_variables.dart'; // Import the global variables file

class CompanyProfile extends StatefulWidget {
  final String firstName;

  const CompanyProfile({Key? key, required this.firstName}) : super(key: key);

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController jobController = TextEditingController();
  TextEditingController requirementController = TextEditingController();

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
  int _selectedIndexCompanyProfile = 1;

  void _onItemTappedCompanyProfile(int index) {
    if (_selectedIndexCompanyProfile != index) {
      setState(() {
        _selectedIndexCompanyProfile = index;
      });
      if (_selectedIndexCompanyProfile == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompHome()),
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
                child: Image.asset("lib/images/company1.jpeg"),
              ),
              SizedBox(height: 50),
              _buildProfileField(
                  'Name', _nameController, CupertinoIcons.person),
              SizedBox(height: 20),
              _buildProfileField(
                  'Address', _addressController, CupertinoIcons.location),
              SizedBox(height: 20),
              _buildProfileField(
                  'Phone', _phoneController, CupertinoIcons.phone),
              SizedBox(height: 20),
              _buildProfileField(
                  'Email', _emailController, CupertinoIcons.mail),
              SizedBox(height: 20),
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
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 110),
                  backgroundColor: Colors.teal.withOpacity(.8),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext Context) {
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: JobTextField(
                              hintText: "Title",
                              controller: jobController,
                            ),
                          ),
                          SizedBox(height: 30),
                          JobTextField(
                            hintText: "Add Requirements",
                            controller: requirementController,
                          ),
                          SizedBox(
                            height: 150,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                                  backgroundColor: Colors.teal,
                                ),
                                onPressed: () {
                                  // Save job details to Firestore
                                  _saveJobDetails(jobController.text, requirementController.text, widget.firstName);
                                  // Close the bottom sheet
                                  Navigator.pop(context);
                                },
                                child: const Text("Done"),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Add Job",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal[200],
        iconSize: 30.0,
        currentIndex: _selectedIndexCompanyProfile,
        onTap: _onItemTappedCompanyProfile,
        items: [
          BottomNavigationBarItem(label: "Comapny Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Company Profile", icon: Icon(Icons.person)),
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

  void _saveJobDetails(String title, String requirements, String firstName) async {
    try {
      // Add job details to Firestore
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': title,
        'requirements': requirements,
        'firstName': globalFirstName, // Use globalFirstName variable
        // Add more fields as needed
      });
      // Show a success message or perform other actions if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job added successfully')),
      );
    } catch (e) {
      // Handle errors
      print('Error adding job: $e');
      // Show an error message or perform other actions if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add job')),
      );
    }
  }
}