import 'package:barter_it2/screens/profilescreen/register.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'login.dart';

//utk profile

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  
  get user => null;

  @override
  void initState() {
    super.initState();
    //print("Profile");
  }

  @override
  void dispose() {
    super.dispose();
    //print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Center(
          child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Card(
                elevation: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                
                Container(
                  margin: const EdgeInsets.all(10),
                  width: screenWidth * 0.5,
                  child: Image.asset(
                    "assets/images/profile.png",
                  ),
                ),
                
              ]),
              )),
          Flexible(
              flex: 1,
              child: Column(
                children: [
                  const SizedBox(height:10),
                  Container(
                    child: const Center(
                      child: Text("PROFILE SETTINGS",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Expanded(
                      child: ListView(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          shrinkWrap: true,
                          children: const [])),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => Login()));
                    },
                    child: const Text("LOGIN"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) =>
                                  const Register()));
                    },
                    child: const Text("REGISTRATION"),
                  ),
                ],
              )),
        ],
      )
       ),
    );
  }
}