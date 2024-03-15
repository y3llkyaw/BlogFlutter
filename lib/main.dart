import 'dart:io';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterblog/Home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Await here
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
    ),
  ));
}

class _MyAppState extends State<MyApp> {
  String? title, des;
  String? selectedImage;

  getTitle(title) {
    this.title = title;
  }

  getDescription(des) {
    this.des = des;
  }

  showToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image.path;
      });
    } else {
      // Handle the case where no image was picked (e.g., user cancelled)
      print('No image selected.');
      showToast("No image Selected");
    }
  }

  Future createData() async {
    print("Creating Data");
    if (selectedImage == null) {
      showToast("Please select Image !");
      return;
    }

    String imgUrl = "";
    //build references starting from the root
    final String uniqueFileName =
        DateTime.now().millisecondsSinceEpoch.toString();
    print("File Name ${uniqueFileName}");
    final storageRef = FirebaseStorage.instance.ref();
    final blogImages = storageRef.child("blogImages");
    final mountainImagesRef = blogImages.child("${uniqueFileName}.jpg");
    try {
      await mountainImagesRef.putFile(File(selectedImage!));
      imgUrl = await mountainImagesRef.getDownloadURL();
      print(imgUrl);
    } catch (error) {
      print(error);
    }

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Blogs').doc(this.title);
    // Placeholder implementation for data creation
    Map<String, dynamic> data = {
      'title': title,
      'des': des,
      'imgUrl': imgUrl,
    };
    documentReference
        .set(data)
        .then((value) => showToast("Data created successfully"))
        .catchError((error) => showToast("Failed to create data"));
    sleep(const Duration(seconds: 2));
    Navigator.pop(context);
  }

  getAllData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Blogs').get();

      List<Map<String, dynamic>> allData = [];

      querySnapshot.docs.forEach((doc) {
        allData.add(doc.data() as Map<String, dynamic>);
      });

      return allData;
    } catch (e) {
      // Handle any potential errors here
      print("Error fetching data: $e");
      return []; // Return an empty list or handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creates New Content"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: selectedImage != null
                ? Container(
                    margin: const EdgeInsets.all(20),
                    height: 200,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        )),
                  )
                : Container(
                    margin: const EdgeInsets.all(20),
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Blog Title",
                fillColor: Colors.white,
              ),
              onChanged: (String value) {
                getTitle(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Blog Description",
                fillColor: Colors.white,
              ),
              onChanged: (String value) {
                getDescription(value);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await createData();
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, dynamic>> allData = await getAllData();
                  print(allData);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent)),
                child: const Text(
                  'Read',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
