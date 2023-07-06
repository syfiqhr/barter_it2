import 'package:barter_it2/screens/barterit/allitems.dart';
import 'package:barter_it2/screens/barteritpage.dart';
import 'package:barter_it2/screens/listing/additem.dart';
import 'package:barter_it2/screens/listing/listitems.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../newscreen.dart';
import 'package:barter_it2/screens/profilescreen/profile.dart';



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
     BarterItPage(user:widget.user),
     Profile(user:widget.user), 
     NewScreen(user:widget.user),
   
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
                  Icons.post_add_rounded,
                ),
                label: "Listing"),
                 BottomNavigationBarItem(
                icon: Icon(
                  Icons.balance,
                ),
                label: "Barter It"), 
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
        maintitle = "Listing";
      } 
      if (_currentIndex == 1) {
        maintitle = "Barter It";
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
