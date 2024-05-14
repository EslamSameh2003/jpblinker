import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'empoloyee_home.dart';

class Jobs extends StatelessWidget {
  final IconData icon;
  final String job;
  final String CName;
  final String details;

  const Jobs({
    Key? key,
    required this.icon,
    required this.job,
    required this.CName,
    required this.details,
  }) : super(key: key);

  // Method to retrieve CV files from Firebase Storage
  Future<List<String>> getCvFilesFromStorage() async {
    // Initialize Firebase Storage
    final storage = FirebaseStorage.instance;

    // Reference to the folder containing CV files in Firebase Storage
    final cvFolderRef = storage.ref().child('cvs');

    // List to store CV file URLs
    List<String> cvFileUrls = [];

    // Get the list of items (CV files) in the folder
    final ListResult result = await cvFolderRef.listAll();

    // Iterate through the items and get the download URL for each CV file
    await Future.forEach(result.items, (Reference ref) async {
      String downloadUrl = await ref.getDownloadURL();
      cvFileUrls.add(downloadUrl);
    });

    return cvFileUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      job,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                // Retrieve CV files from Firebase Storage
                List<String> cvFileUrls = await getCvFilesFromStorage();

                // Display the list of CV files
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Choose a CV',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: cvFileUrls.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text('CV ${index + 1}'),
                                      onTap: () {
                                        // Handle the selected CV file
                                        String selectedCvUrl = cvFileUrls[index];
                                        print('Selected CV URL: $selectedCvUrl');
                                        // Close the bottom sheet
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child:
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                  onPressed: (){

                                  Navigator.pop(context,EmployeeHome());
                                  },

                                  child:Text(
                                    "Done",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Apply",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
