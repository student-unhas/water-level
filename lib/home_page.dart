import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    readData();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Water \nControl",
                  style: TextStyle(
                      color: Color(0xff007be3),
                      fontSize: 40,
                      height: 1,
                      fontWeight: FontWeight.w600),
                ),
                const Text(
                  "Smart Home",
                  style: TextStyle(
                      color: Color(0xff007be3),
                      fontSize: 20,
                      height: 1,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: dbRef.child("data").onValue,
                      builder: (context, snapshot) {
                        print(snapshot.data?.snapshot);
                        if (snapshot.hasData &&
                            !snapshot.hasError &&
                            snapshot.data?.snapshot != null) {
                          final jsonData =
                              jsonEncode(snapshot.data!.snapshot.value);

                          var sensorData =
                              SensorData.fromJson(jsonDecode(jsonData));

                          return Row(
                            children: [
                              Expanded(
                                child: CardWidget(
                                  title: "Water Level",
                                  desc: sensorData.level,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.2),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Expanded(
                                                flex: int.parse(
                                                            sensorData.level) >
                                                        100
                                                    ? 0
                                                    : 100 -
                                                        int.parse(
                                                            sensorData.level),
                                                child: const SizedBox()),
                                            Expanded(
                                              flex: int.parse(
                                                          sensorData.level) >
                                                      100
                                                  ? 100
                                                  : int.parse(sensorData.level),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff007be3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Center(
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(.5),
                                                shape: BoxShape.circle),
                                            child: Center(
                                                child: Text(
                                              int.parse(sensorData.level) > 100
                                                  ? "100%"
                                                  : "${sensorData.level}%",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> readData() async {
    print('sdsd');
    // dbRef.child("data").once().then((DatabaseEvent value) {
    //   print("value.snapshot.value");
    //   print(value.snapshot.value);
    // });

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('data').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }
}

class SensorData {
  final String level;

  SensorData({required this.level});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      level: json['level'].toString(),
    );
  }

  @override
  String toString() {
    return 'SensorData{temperature:  level: $level}';
  }
}

class CardWidget extends StatelessWidget {
  final String? title, desc, iconTitle;
  final IconData? icon;
  const CardWidget(
      {super.key, this.desc, this.icon, this.iconTitle, this.title});

  @override
  Widget build(BuildContext context) {
    int level = int.parse(desc ?? "0");
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const IconWidget(),
            Text(
              "Matikan Pompa",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: level > 90
                      ? const Color(0xff44966a)
                      : Colors.grey.withOpacity(.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "Air Tersedia",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: level > 40 && level < 90
                      ? const Color(0xff44966a)
                      : Colors.grey.withOpacity(.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "Nyalakan Pompa",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: level < 40
                      ? const Color(0xff44966a)
                      : Colors.grey.withOpacity(.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ]),
    );
  }
}

class IconWidget extends StatelessWidget {
  const IconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff44966a),
              Color(0xff92eb84),
            ],
          )),
      child: const Center(
          child: Icon(
        FontAwesomeIcons.droplet,
        color: Colors.white,
      )),
    );
  }
}
