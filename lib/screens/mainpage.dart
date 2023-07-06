import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import '../models/user.dart';
import '../myconfig.dart';
import 'mainpage/itemdetails.dart';


class MainPage extends StatefulWidget {
  final User user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController searchController = TextEditingController();
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Item> itemList = <Item>[];
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  int cartqty = 0;
  var color;

  @override
  void initState() {
    super.initState();
    _loadItems(1);
  }

  @override
  void dispose() {
    super.dispose();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.teal,
                Colors.cyan.shade300,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ListTile(
                  title: const Text(
                    "Home Page",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showsearchDialog();
                          },
                          icon: const Icon(Icons.search)),
                    /*  IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                   // Cart(user: widget.user)));
                                    //kena buat showcart
                          }, 
                          icon: const Icon(Icons.shopping_cart))*/
                    ],
                  )),
            ),
          ),
        ),
      ),
      body: itemList.isEmpty
          ? const Center(child: Text("No Data Available"))
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Colors.blueGrey,
                  alignment: Alignment.center,
                  child: Text(
                    "$numberofresult Items Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return Future.delayed(const Duration(seconds: 1), () {});
                    },
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return GridTile(
                            header: GridTileBar(
                              backgroundColor: Colors.black26,
                              leading: const Icon(Icons.timer_sharp),
                              title: Text("${itemList[index].itemDate}"),
                            ),
                            child: Card(
                              child: InkWell(
                                onTap: () async {
                                  Item itemIndex =
                                      Item.fromJson(itemList[index].toJson());
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => ItemDetails(
                                                user: widget.user,
                                                itemIndex: itemIndex,
                                              )));
                                  _loadItems(1);
                                },
                                child: Column(children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barter_it2/assets/items/${itemList[index].itemId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(
                                    itemList[index].itemName.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "RM ${itemList[index].itemPrice.toString()}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${itemList[index].itemQty} available",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          //build the list for textbutton with scroll
                          if ((curpage - 1) == index) {
                            //set current page number active
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return TextButton(
                              onPressed: () {
                                curpage = index + 1;
                                _loadItems(index + 1);
                              },
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        }))
              ],
            ),
    );
  }

  void _loadItems(int pg) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": pg.toString(),
        }).then((response) {
      log(response.body);
      itemList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        /*if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);

          var extractdata = jsondata['data'];
          cartqty = int.parse(jsondata['item_qty'].toString());
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v)); 
          });
        } */

 if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['items'] != null) {
            print("Success");
            setState(() {
              numofpage = int.parse(jsondata['numofpage']);
              numberofresult = int.parse(jsondata['numberofresult']);
              itemList = List<Item>.from(
                extractdata['catches'].map((toolJson) => Item.fromJson(toolJson)),
              );
              //titlecenter = "Found";
    });
  }
}
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Enter search name...',
                    labelStyle: TextStyle(fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
          ]),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  String search = searchController.text;
                  searchCatch(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search")),
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

  void searchCatch(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
 if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['items'] != null) {
            print("Success");
            setState(() {
              numofpage = int.parse(jsondata['numofpage']);
              numberofresult = int.parse(jsondata['numberofresult']);
              itemList = List<Item>.from(
                extractdata['catches'].map((toolJson) => Item.fromJson(toolJson)),
              );
              //titlecenter = "Found";
    });
  }
}
      }
    });
  }
}