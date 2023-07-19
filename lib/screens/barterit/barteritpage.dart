import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/item.dart';
import '../../models/user.dart';
import '../../main/myconfig.dart';
import 'cartlist2.dart';
import 'itemdetails2.dart';


class BarterScreen extends StatefulWidget {
  final User user;
  const BarterScreen({super.key, required this.user});

  @override
  State<BarterScreen> createState() => _BarterScreenState();
}

class _BarterScreenState extends State<BarterScreen> {
  String maintitle = "Barter";
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
    loadItem(1);
    print("Barter");
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
    if (screenWidth > 30) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(maintitle),
          foregroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            IconButton(
                onPressed: () {
                  showsearchDialog();
                },
                icon: const Icon(Icons.search)),
           TextButton.icon(
              onPressed: () {
                if (cartqty  > 0) {
                  Navigator.push(
                      context,
                       MaterialPageRoute(
                          builder: (content) => CartList2(
                                user: widget.user,
                              )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No item in cart")));
                }
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text(cartqty.toString()),
            ), 
            
          ],
        ),
        body: catchList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : Column(
                children: [
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
                    children: List.generate(catchList.length, (index) {
                      return Card(
                        child: InkWell(
                          onLongPress: () {
                            //   onDeleteDialog(index);
                          },
                          onTap: () async {
                            Item useritem =
                                Item.fromJson(catchList[index].toJson());
                            await Navigator.push(
                                context,
                                 MaterialPageRoute(
                                      builder: (content) => ItemDetails2(
                                            user: widget.user,
                                                     item: useritem,
                                       
                                          ))); 
                            loadItem(1);
                          }, 
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/barter_it2/assets/items/${catchList[index].itemId}_1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                catchList[index].itemName.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "RM ${double.parse(catchList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${catchList[index].itemQty} available",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  )),
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
                              loadItem(index + 1);
                            },
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color, fontSize: 18),
                            ));
                      },
                    ),
                  ),
                ],
              ));
  }

  void loadItem(int pg) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items3.php"),
        body: {
          "user_id": widget.user.id,
          "numberofpage": pg.toString()
        }).then((response) {
      //print(response.body);
      log(response.body);
      catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
         //print(numberofresult);
          var extractdata = jsondata['data'];
           cartqty  = int.parse(jsondata['cart_qty'].toString());
           //print(cartqty);
          extractdata['catches'].forEach((v) {
            catchList.add(Item.fromJson(v));
          });
          print(catchList[0].itemName);
        }
        setState(() {});
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Search Item",
                style: TextStyle(),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Type the name of item ',
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
                  searchitem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
        );
      },
    );
  }

  void searchitem(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_items3.php"),
        body: {"user_id": widget.user.id, "search": search}).then((response) {
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
}