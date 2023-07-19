import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/cartinfo.dart';
import '../../models/user.dart';
import '../../main/myconfig.dart';

//shopee punya cart list 

class CartList2 extends StatefulWidget {
  final User user;
  const CartList2({super.key, required this.user});

  @override
  State<CartList2> createState() => _CartList2State();
}

class _CartList2State extends State<CartList2> {
  List<Cart> cartList = <Cart>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    loadcart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          cartList.isEmpty
              ? const Center(
                  child: Text("No Items in Cart"),
                )
              : Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      int qty = int.parse(cartList[index].cartQty.toString());
                      int maxqty =
                          int.parse(cartList[index].itemQty.toString());

                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl:
                              "${MyConfig().SERVER}/barter_it2/assets/items/${cartList[index].itemId}_1.png",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        title: Text("${cartList[index].itemName}"),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("${cartList[index].itemDesc}")),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "RM ${cartList[index].cartPrice}",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (qty < maxqty) {
                                        _addItems(index);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Reached Maximum Quantity")));
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text("${cartList[index].cartQty}")),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (qty <= 1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Reached Minimum Quantity")));
                                      } else {
                                        _removeItems(index);
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.cyan),
                          onPressed: () {},
                        ),
                      );
                    },
                    itemCount: cartList.length,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
          Stack(
            children: [
              Card(
                elevation: 12,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(16, 12))),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.elliptical(16, 12))),
                  height: 80,
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Total: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("RM $totalprice",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ],
                      ),
                      trailing: MaterialButton(
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          color: Colors.teal[300],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Propose Trade",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void loadcart() {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/load_cart2.php?user_id=1"),
        body: {
          "user_id": widget.user.id,
        }).then((response) {
      log(response.body);
      cartList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
        }
        totalprice = cartList.fold(
            0.0,
            (previous, current) =>
                previous + int.parse(current.cartPrice.toString()));
        setState(() {});
      }
    });
  }

  void _addItems(index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/post_items.php"), //not yet
        body: {
          "item_id": cartList[index].itemId,
          "cart_qty": cartList[index].cartQty,
          "cart_price": cartList[index].cartPrice,
          "user_id": widget.user.id,
          "seller_id": cartList[index].sellerId
        }).then((response) {
      // print("$num $total");
      // print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {}
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      }
    });
    setState(() {
      loadcart();
    });
  }

  void _removeItems(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/removeitems.php"), // not yet 
        body: {
          "item_id": cartList[index].itemId,
          "cart_qty": cartList[index].cartQty,
          "cart_price": cartList[index].cartPrice,
          "user_id": widget.user.id,
          "seller_id": cartList[index].sellerId
        }).then((response) {
      // print("$num $total");
      // print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {}
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      }
    });
    setState(() {
      loadcart();
    });
  }
}