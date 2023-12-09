import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a2744),
      appBar: AppBar(
        backgroundColor: const Color(0xff2a2744),
        title: const Text(
          "Water Control",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CardWidget(
                  title: "Water Level",
                  desc: "50%",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String? title, desc, iconTitle;
  final IconData? icon;
  const CardWidget(
      {super.key, this.desc, this.icon, this.iconTitle, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff3a395b)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const IconWidget(),
          const SizedBox(
            height: 30,
          ),
          Text(
            title ?? "not found",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            desc ?? "not found",
            style: const TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500),
          )
        ]),
      ),
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
