import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
    final String place;
  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {

    Future<Map<String, dynamic>> getDataFromAPI() async {
        final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=53d23dd74c698c7d46ca137f73eebc24&units=metric"));       

        if(response.statusCode == 200){
            final data = json.decode(response.body);
            
            return data;
        } else {
            throw Exception("Error!");
        }
    }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text(
                    "Hasil Tracking", 
                    style: TextStyle(color: Colors.white),
                    ), 
                    centerTitle: true,
                    backgroundColor: Colors.blueAccent,
                    leading: GestureDetector(
                        onTap: () {
                            Navigator.pop(context);
                        },
    
                     child: const Icon(Icons.arrow_back, color: Colors.white,),
            ) ),

            body: Container(
                padding: EdgeInsets.only(left: 70, right: 70),

                child:FutureBuilder(
                    future: getDataFromAPI(), 
                    builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData) {
                            final data = snapshot.data!;

                           return Center(
                            child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        Text(
                                            '${data["name"]}',
                                            style: const TextStyle(fontSize: 30),
                                        ),
                                        Image(
                                            image: NetworkImage(
                                                "https://flagsapi.com/${data["sys"]["country"]}/shiny/64.png"),
                                        ),
                                        Text(
                                            "${data["main"]["feels_like"]} °C",
                                            style: const TextStyle(fontSize: 40),
                                        ),
                                        Text(
                                            '${data["wind"]["speed"]} m/s',
                                            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                            '${data["weather"][0]["description"]}',
                                            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                                        ),
                                    ],
                                ),
                            ),
                        );

                        } else {
                            return const Text("Tempat tidak diketahui");
                        }
                    }
                    ),
                    
            )
        ),
    );
  }
}
