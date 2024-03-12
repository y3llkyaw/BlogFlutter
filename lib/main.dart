import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterblog/Home.dart';

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

  getTitle(title) {
    this.title = title;
  }

  getDescription(des) {
    this.des = des;
  }

  createData() {
    print("Created Data");
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Blogs').doc(this.title);
    // Placeholder implementation for data creation
    Map<String, dynamic> data = {
      'title': title,
      'des': des,
    };
    documentReference
        .set(data)
        .then((value) => print("Data created successfully"))
        .catchError((error) => print("Failed to create data: $error"));
  }

  getAllData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Blogs').get();

    List<Map<String, dynamic>> allData = [];

    querySnapshot.docs.forEach((doc) {
      // Convert each document to a Map and add it to the list
      allData.add(doc.data() as Map<String, dynamic>);
    });
    print(allData);
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creates New Content"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            height: 200,
            decoration:  BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Icon(Icons.add_a_photo),
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
                onPressed: () {
                  createData();
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  List<Map<String, dynamic>> allData = getAllData();
                  print(allData);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),
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
