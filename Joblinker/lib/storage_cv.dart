import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'EmployeeProfile.dart';

class AddCv extends StatefulWidget {
  const AddCv({Key? key}) : super(key: key);

  @override
  State<AddCv> createState() => _AddCvState();
}

class _AddCvState extends State<AddCv> {
  List<File> cvFiles = [];

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        cvFiles.addAll(files);
      });
    }
  }

  removeCv(int index) {
    setState(() {
      cvFiles.removeAt(index);
    });
  }

  Future<void> uploadCvToFirestore(File cvFile) async {
    try {
      // Get file name
      String fileName = cvFile.path.split('/').last;

      // Upload CV to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('cvs/$fileName');
      await ref.putFile(cvFile);

      // Get download URL
      String downloadURL = await ref.getDownloadURL();

      // Store CV metadata in Firestore
      await FirebaseFirestore.instance.collection('cvs').add({
        'fileName': fileName,
        'downloadURL': downloadURL,
        // Add more metadata fields if needed, such as user ID, timestamp, etc.
      });
    } catch (e) {
      print('Error uploading CV: $e');
    }
  }

  Future<void> deleteCvFromDatabase(String fileName) async {
    try {
      // Delete CV from Firebase Storage
      await FirebaseStorage.instance.ref('cvs/$fileName').delete();

      // Delete CV metadata from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('cvs').where('fileName', isEqualTo: fileName).get();
      querySnapshot.docs.forEach((doc) async {
        await FirebaseFirestore.instance.collection('cvs').doc(doc.id).delete();
      });
    } catch (e) {
      print('Error deleting CV: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => EmployeeProfile()),
            );
          },
          child: Icon(Icons.arrow_back_sharp, color: Colors.black),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              const Text(
                "Storage Cv",
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.teal.withOpacity(.2),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Text(
                          "Add Cv",
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await getFile();
                          // Upload each CV to Firestore
                          for (File cvFile in cvFiles) {
                            await uploadCvToFirestore(cvFile);
                          }
                        },
                        child: const Icon(Icons.attach_file, size: 25),
                      ),
                    ),
                  ],
                ),
              ),
              ...cvFiles.asMap().entries.map(
                    (entry) {
                  int index = entry.key;
                  File cvFile = entry.value;
                  String fileName = cvFile.path.split('/').last;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue.withOpacity(.28),
                    ),
                    child: ListTile(
                      title: Text('CV${index + 1}'),
                      subtitle: Text(cvFile.path),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeCv(index);
                          deleteCvFromDatabase(fileName);
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
