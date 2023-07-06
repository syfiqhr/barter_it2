import 'dart:convert';
import 'dart:developer';
import 'package:barter_it2/screens/listing/additem.dart';
import 'package:barter_it2/screens/listing/listitems.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import '../models/user.dart';
import '../myconfig.dart';

class BarterItPage extends StatefulWidget {
  final User user;
  const BarterItPage({super.key, required this.user});

  @override
  State<BarterItPage> createState() => _BarterItPageState();
}

class _BarterItPageState extends State<BarterItPage> {
   String maintitle = "Listing";
  List<Item> catchList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int cartqty = 0;
  late List<Widget> tabchildren;
  String dialog = "No Data Available";

  List<Item> itemList = <Item>[];
  @override
  void initState() {
    super.initState();
    loadTradeItems();
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
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.deepPurpleAccent,
        activeForegroundColor: Colors.white,
        childrenButtonSize: const Size.fromRadius(40.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () {
          debugPrint('OPENING DIAL');
        },
        onClose: () {
          debugPrint('DIAL CLOSED');
        },
        elevation: 8.0,
        shape: const CircleBorder(),
        childPadding: const EdgeInsets.all(8),
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
                    builder: (BuildContext context) =>
                    //list item
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
         SpeedDialChild(
            child: const Icon(Icons.edit_document),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Manage Listing',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ListItems (user: widget.user)));
            },
            onLongPress: () {},
          ),
        ],
      ),
      body: itemList.isEmpty
          ? Center(
              child: Text(dialog),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "${itemList.length} Items Found",
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
                          header:  GridTileBar(
                            backgroundColor: Colors.black38,
                            leading: const Icon(Icons.timer_sharp),
                            title: Text("${itemList[index].itemDate}"),
                          ),
                          child: Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () {
                                _showDetails(index);
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
                    )),
              ))
            ]),
    );
  }

  void loadTradeItems() {
    if (widget.user.id == "N/A") {
      setState(() {
        itemList.clear();
        dialog = "Register/Login Account to Trade";
      });
      return;
    }

    
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items.php"),
        body: {
          "userid": widget.user.id,
      
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

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
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

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then(
      (response) {
        debugPrint(response.body);
        //itemList.clear();
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Delete Success")));
            loadTradeItems();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Failed")));
          }
        }
      },
    );
  }

  void _showDetails(index) {
    showBottomSheet(
      elevation: 20,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 550,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close")),
                ),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().SERVER}/barter_it2/assets/items/${itemList[index].itemId}.png",
                      ),
                    ),
                   /* const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().SERVER}/barter_it/assets/items/${itemList[index].itemId}_2.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().SERVER}/barter_it/assets/items/${itemList[index].itemId}_3.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyConfig().SERVER}/barter_it/assets/items/${itemList[index].itemId}_4.png",
                      ),
                    ), */
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
                  child: Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(itemList[index].itemName.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              )),
                          title:
                              Text("# ${itemList[index].itemQty.toString()}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: Text(
                              "RM ${itemList[index].itemPrice.toString()}"),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 4, 0),
                          minVerticalPadding: 0,
                        ),
                        ListTile(
                          leading: const Icon(Icons.type_specimen),
                          title: Text(itemList[index].itemType.toString()),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 4, 0),
                          minVerticalPadding: 0,
                          subtitle: Text(itemList[index].itemDesc.toString()),
                        ),
                        ListTile(
                          leading: const Icon(Icons.document_scanner),
                          title: const Text("Conditions"),
                          subtitle:
                              Text(itemList[index].itemCondition.toString()),
                        ),
                        ListTile(
                          leading: const Icon(Icons.pin_drop),
                          title: const Text("Location"),
                          subtitle: Text(
                              "${itemList[index].itemState.toString()}, ${itemList[index].itemLocality.toString()}"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 
  /*
import 'dart:convert';
import 'dart:developer';
import 'package:barter_it2/models/item.dart';
import 'package:barter_it2/screens/listing/additem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../myconfig.dart';

// for fisherman screen

class SellerTabScreen extends StatefulWidget {
  final User user;

  const SellerTabScreen({super.key, required this.user});

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Seller";
  List<Item> catchList = <Item>[];

  @override
  void initState() {
    super.initState();
    loadsellerCatches();
    print("Seller");
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
                  "${catchList.length} Catches Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        catchList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Item singlecatch =
                                    Item.fromJson(catchList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => AddItem(
                                              user: widget.user,
                                             // Item : Item
                                            )));
                                loadsellerCatches();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barter_it2/assets/catches/${catchList[index].itemId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  catchList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "RM ${double.parse(catchList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${catchList[index].itemQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => AddItem(
                            user: widget.user,
                          )));
              loadsellerCatches();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  void loadsellerCatches() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/mynelayan/php/load_catches.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      log(response.body);
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['catches'].forEach((v) {
            catchList.add(Item.fromJson(v));
          });
          print(catchList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${catchList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteCatch(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
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

  void deleteCatch(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/delete_catch.php"),
        body: {
          "userid": widget.user.id,
          "catchid": catchList[index].itemId
        }).then((response) {
      print(response.body);
      //catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadsellerCatches();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}  */