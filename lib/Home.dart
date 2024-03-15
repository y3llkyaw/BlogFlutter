import 'package:flutter/material.dart';
import 'package:flutterblog/BlogList.dart';
import 'package:flutterblog/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> futureBlogs;

  @override
  void initState() {
    super.initState();
    futureBlogs = fetchData(); // Call a function to fetch data
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
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
      throw e; // Rethrow the error to be handled by the calling function
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Blogs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureBlogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            List<Map<String, dynamic>> blogs = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: BlogTile(
                      imgUrl: blogs[index]['imgUrl'],
                      title: blogs[index]['title'],
                      des: blogs[index]['des'],
                    ),
                  ); // Replace null with your widget
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
