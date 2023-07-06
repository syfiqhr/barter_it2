import 'package:flutter/material.dart';

import 'models/user.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key, required User user});

  @override
  State<NewScreen> createState()=> _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  String maintitle = "News";

@override
void initState() {
  super.initState();
  print("News");
}

@override
void dispose() {
  super.dispose();
  print("dispose");
}

 @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(maintitle),
    );
  }
}