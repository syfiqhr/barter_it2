import 'dart:convert';
import 'package:barter_it2/screens/payment/checkout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/item.dart';
import '../../models/user.dart';
import '../../main/myconfig.dart';

class ItemDetails4 extends StatefulWidget {
  final User user;
  final Item item;
  const ItemDetails4({super.key, required this.user, required this.item});


  @override
  State<ItemDetails4> createState() => _ItemDetails4State();
}

class _ItemDetails4State extends State<ItemDetails4> {
  int currentImageIndex = 0;
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;
  int barterfees = 2;

  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.item.itemQty.toString());
    totalprice = double.parse(widget.item.itemPrice.toString());
    singleprice = double.parse(widget.item.itemPrice.toString());
  }

 // final df = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    List<String> imageUrls = [
      "${MyConfig().SERVER}/barter_it2/assets/items/${widget.item.itemId}_1.png",
      "${MyConfig().SERVER}/barter_it2/assets/items/${widget.item.itemId}_2.png",
      "${MyConfig().SERVER}/barter_it2/assets/items/${widget.item.itemId}_3.png",
      "${MyConfig().SERVER}/barter_it2/assets/items/${widget.item.itemId}_4.png",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Your Barter Item Request")),
      body: Column(
        children: [
          Flexible(
              flex: 8,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                addAutomaticKeepAlives: false,
                shrinkWrap: true,
                
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 10, 0),
                    child: Card(
                      child: Container(
                        width: screenWidth,
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.contain,

                        ),
                      ),
                    ),
                  );
                },
              )),
          Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.item.itemName.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(4),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.item.itemDesc.toString(),
                    ),
                  )
                ]),
                
                // TableRow(children: [
                //   const TableCell(
                //     child: Text(
                //       "Quantity Available",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ),
                //   TableCell(
                //     child: Text(
                //       widget.item.itemQty.toString(),
                //     ),
                //   )
                // ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.item.itemPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.item.itemLocality}/${widget.item.itemState}",
                    ),
                  )
                ]),
              ],
            ),
          ),
        
        ),
        // Expanded(
        //   flex: 3,
        //   child: Column(
        //   children: [
        //     Container(
        //   padding: const EdgeInsets.all(0),
        //   child:
        //       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //     IconButton(
        //         onPressed: () {
        //           if (userqty <= 1) {
        //             userqty = 1;
        //             totalprice = singleprice * userqty;
        //           } else {
        //             userqty = userqty - 1;
        //             totalprice = singleprice * userqty;
        //           }
        //           setState(() {});
        //         },
        //         icon: const Icon(Icons.remove)),
        //     Text(
        //       userqty.toString(),
        //       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        //     ),
        //     IconButton(
        //         onPressed: () {
        //           if (userqty >= qty) {
        //             userqty = qty;
        //             totalprice = singleprice * userqty;
        //           } else {
        //             userqty = userqty + 1;
        //             totalprice = singleprice * userqty;
        //           }
        //           setState(() {});
        //         },
        //         icon: const Icon(Icons.add)),
        //   ]),
        // ),
        // Text(
        //   "RM ${totalprice.toStringAsFixed(2)}",
        //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        // ElevatedButton(
        //     onPressed: () {
        //       addtocartdialog();
        //       },
        //     child: const Text(" Add to Cart ")),
              
        //       ElevatedButton(
        //         onPressed: () {
        //       addpaymentdialogue();
        //       },
        //     child: const Text(" Checkout Item ")),
        //         // onPressed: ()async{
        //         //     await Navigator.push(
        //         //       context,
        //         //       MaterialPageRoute(
        //         //         builder: (content)=> CheckOutOption(
        //         //         user: widget.user,
        //         //         item: widget.item, )));}, 
        //         //         style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
        //         //         child: const Text("Check Out Item", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      

          ],
        ));

    //     ],
    //   ),
    // );
  }
  
//   void addtocartdialog() {
    
//      if (widget.user.id.toString() == "na") {                           // unregister user cannot add
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please register to add item to cart")));
//       return;
//     }
//     if (widget.user.id.toString() == widget.item.userId.toString()) {
//       // Fluttertoast.showToast(
//       //     msg: "User cannot add own item",
//       //     toastLength: Toast.LENGTH_SHORT,
//       //     gravity: ToastGravity.CENTER,
//       //     timeInSecForIosWeb: 1,
//       //     fontSize: 16.0);
//       ScaffoldMessenger.of(context).showSnackBar(
//            const SnackBar(content: Text("Please login/register to continue")));
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: const Text(
//             "Make a payment",
//             style: TextStyle(),
//           ),
//           content: const Text("You will be directed to payment page. Are you sure?", 
//           style: TextStyle()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Yes",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 //deductCoin();
//                 addtocart();
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 "No",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
  
//   void addtocart() {
//     http.post(Uri.parse("${MyConfig().SERVER}/barter_it2/php/addtocart.php"),
//         body: {
//           "item_id": widget.item.itemId.toString(),
//           "cart_qty": userqty.toString(),
//           "cart_price": totalprice.toString(),
//           "user_id": widget.user.id.toString(),
//           "seller_id": widget.item.userId.toString(),
//     }).then((response){
//       print(response.body);
//       if(response.statusCode == 200){
//          var jsondata = jsonDecode(response.body);
//          if(jsondata['status'] == 'success'){
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Success")));
//          }else{
//            ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Please login/register to continue")));
//          }
//          Navigator.pop(context);   
//       }else{
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Please login/register to continue")));
//         Navigator.pop(context);
//       }
//      });

//   }
  
//  /* Future<void> deductCoin() async {
    
//     await http.post(
//         Uri.parse(
//             "${MyConfig().SERVER}/barter_it2/php/coin.php"), // Need to change
//         body: {
//           "selectcoin": barterfees.toString(),
//           "user_id": widget.user.id,
//         }).then((response) {
//       print(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);

//         if (jsondata['status'] == "success") {
//           //user = User.fromJson(jsondata['data']);   //error
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Payment Success")));
//         } else {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Payment Fail")));
//         }
//       }
//       setState(() {});
//     }).timeout(const Duration(seconds: 5));
//   } */

//   void checkoutdialog () {}
  
//   void addpaymentdialogue() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: const Text(
//             "Make a payment",
//             style: TextStyle(),
//           ),
//           content: const Text("You are required to pay RM2.00 to continue with the barter process", 
//           style: TextStyle()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Confirm",
//                 style: TextStyle(),
//               ),
//               onPressed: ()async{
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (content)=> CheckOutOption(
//                         user: widget.user,
//                         item: widget.item, )));}, 
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//             ),
//             TextButton(
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}