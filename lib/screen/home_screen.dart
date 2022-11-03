import 'dart:convert';
import 'package:asaba_connect/model/photo.dart';
import 'package:asaba_connect/util/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future getPhotos() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    List photos = [];
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var body in body) {
        Photo photo = Photo.fromJson(body);
        photos.add(photo);
      }
    } else {
      throw Exception('Erro getting data');
    }
    return photos;
  }

  @override
  void initState() {
    getPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: textInfo("Contacts", FontWeight.w600, Colors.white, 25),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              clipBehavior: Clip.none,
              child: const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    fillColor: Color.fromARGB(31, 255, 255, 255),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white24,
                    ),
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white24)),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 15),
                width: double.infinity,
                clipBehavior: Clip.none,
                child: textInfo(
                    'Favourites', FontWeight.normal, Colors.white, 14)),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.zero,
              child: FutureBuilder(
                future: getPhotos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${snapshot.data[index].url}.png"))),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: textInfo(
                                      snapshot.data[index].id.toString(),
                                      FontWeight.normal,
                                      Colors.white,
                                      14))
                            ],
                          );
                        });
                  } else {
                    return Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 500,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
            )
          ],
        ),
      ),
    );
  }
}
