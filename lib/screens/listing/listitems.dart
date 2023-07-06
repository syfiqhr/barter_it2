import 'dart:convert';
import 'dart:developer';

import 'package:barter_it2/models/item.dart';
import 'package:barter_it2/models/user.dart';
import 'package:barter_it2/myconfig.dart';
import 'package:barter_it2/screens/listing/additem.dart';
import 'package:barter_it2/screens/mainpage/itemdetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;


//for buyer screen

class ListItems extends StatefulWidget {
  final User user;
  const ListItems({super.key, required this.user});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  String maintitle = "Listing";
  List<Item> catchList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int cartqty = 0;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadCatches(1);
    print("Listing");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
          TextButton.icon(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ), // Your icon here
            label: Text(cartqty.toString()), // Your text here
            onPressed: () {
              if (cartqty > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => AddItem(  //nnt letak cart screen
                              user: widget.user,
                            )));
              }else{
                 ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No item in cart")));
              }
            },
          ) 
          
        ],
      ),
      body: catchList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "$numberofresult Item Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      //childAspectRatio: (screenWidth * 50 )/ (screenHeight * 0.8),
                      children: List.generate(
                        catchList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                Item item =
                                    Item.fromJson(catchList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            ItemDetails(
                                              user: widget.user,
                                              itemIndex : item,
                                              //usercatch: usercatch,
                                            )));
                                loadCatches(1);
                              }, 
                              child: Column(children: [
                                CachedNetworkImage(

                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barter_it2/assets/items/${catchList[index].itemId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  catchList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 17, color: Colors.black),
                                ),
                                Text(
                                  "RM ${double.parse(catchList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "${catchList[index].itemQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            ),
                          );
                        },
                      ))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //build the list for textbutton with scroll
                    if ((curpage - 1) == index) {
                      //set current page number active
                      color = Color.fromARGB(255, 203, 143, 163);
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadCatches(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
            ]),

                        floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.upload),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Upload Items',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () async {
              if (widget.user.id != "N/A") {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contjext) =>
                        AddItem(user: widget.user)));
              } else {
                ScaffoldMessenger.of(context).showMaterialBanner(
                  MaterialBanner(
                    padding: const EdgeInsets.all(15),
                    content: const Text("Please Register/Login an Account"),
                    leading: const Icon(Icons.warning_amber),
                    elevation: 5,
                    backgroundColor: Colors.grey[300],
                    actions: [
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner();
                          },
                          child: const Text("Dismiss"))
                    ],
                  ),
                );
              }
            },
            onLongPress: () {},
          ),
          /*SpeedDialChild(
            child: const Icon(Icons.edit_document),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Manage My Items',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ListItems(user: widget.user)));
            },
            onLongPress: () {},
          ),*/
        ],
      ));
  }

    Future <void> loadCatches(int pg) async {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items.php"),
        body: {
          "userid": widget.user.id,
          "numberofpage": pg.toString()
        }).then((response) {
          //print(response.body);
      log(response.body);
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
          if (extractdata['catches'] != null) {
            print("Success");
            setState(() {
              numofpage = int.parse(jsondata['numofpage']);
              numberofresult = int.parse(jsondata['numberofresult']);
              catchList = List<Item>.from(
                extractdata['catches'].map((toolJson) => Item.fromJson(toolJson)),
              );
              print(catchList[0].itemName);
              //titlecenter = "Found"; 
    });
  }
}    /*   if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['catches'].forEach((v) {
            catchList.add(Item.fromJson(v));
          });
          print(catchList[0].itemName); 
      } */
    }});
  }
  

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchCatch(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future <void> searchCatch(String search) async{
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
      //print(response.body);
      log(response.body);
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
          if (extractdata['catches'] != null) {
            print("Success");
            setState(() {
              numofpage = int.parse(jsondata['numofpage']);
              numberofresult = int.parse(jsondata['numberofresult']);
              print(numberofresult);
              catchList = List<Item>.from(
                extractdata['catches'].map((toolJson) => Item.fromJson(toolJson)),
              );
              print(catchList[0].itemName);
              //titlecenter = "Found"; 
    });
  }
}  
      }
    });
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
} 