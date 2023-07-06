
import 'package:flutter/material.dart';

import '../../models/user.dart';

class AllItems extends StatefulWidget {
  final User user;
  const AllItems({Key? key, required this.user}): super(key: key);
  
  @override
  State<AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  String maintitle = "Buyer";
  int _currIndex = 2;

  @override
  void initState(){
    super.initState();
    print("Barter It");
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(maintitle),
    );
  }
}