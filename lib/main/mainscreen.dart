import 'package:barter_it2/screens/news/newscreen.dart';
import 'package:barter_it2/screens/profilescreen/profile2.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/barterit/barteritpage.dart';
import '../screens/listing/listitems.dart';

class MainScreen extends StatefulWidget {
final User user;

const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Barter It";

  @override
  void initState() {
    super.initState();
    tabchildren = [
     ListItems(user:widget.user),
     BarterIt(user:widget.user),
     ProfileTabScreen(user:widget.user), 
     NewScreen(user:widget.user)       
    ];
  }

  @override
  void dispose() {
    super.dispose();
    //print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [ 
                 BottomNavigationBarItem(
                icon: Icon(
                  Icons.balance,
                ),
                label: "Barter It"), 
                 BottomNavigationBarItem(
                icon: Icon(
                  Icons.post_add_rounded,
                ),
                label: "Listing"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.newspaper,
                ),
                label: "News")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Barter It";
      } 
      if (_currentIndex == 1) {
        maintitle = "Listing";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
      if (_currentIndex == 3) {
        maintitle = "News";
      }
    });
  }
}
