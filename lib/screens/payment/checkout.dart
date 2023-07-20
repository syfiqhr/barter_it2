import 'package:barter_it2/screens/barterit/itemdetails4.dart';
import 'package:barter_it2/screens/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/item.dart';
import '../../models/user.dart';
import '../listing/listitems.dart';

class CheckOutOption extends StatefulWidget {
  final User user;
  final Item item;
  const CheckOutOption({super.key, required this.user, required this.item});

  @override
  State<CheckOutOption> createState() => _CheckOutOptionState();
}

class _CheckOutOptionState extends State<CheckOutOption> {
  Map<String, dynamic>? paymentIntent;
  int groupValue=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barter It"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            // Container(
            //   height: 80,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12.0),
            //     border: Border.all(width: 3.0),
            //   ),
            //   // child: Row(
            //   //   children: [
            //   //     Radio(value: 1, groupValue: groupValue, onChanged: (value){
            //   //       setState(() {
            //   //         groupValue=value!;
            //   //       });
            //   //     },),
            //   //     const Icon(Icons.money),
            //   //     const SizedBox(width: 12,),
            //   //     const Text("Cash on Delivery", 
            //   //     style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold),),
            //   //   ],
            //   // ),
            // ),
            const SizedBox(
              height: 24),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 3.0),
              ),
              child: Row(
                children: [
                  Radio(value: 2, groupValue: groupValue, onChanged: (value){
                    setState(() {
                      groupValue=value!;
                    });
                  },),
                  const Icon(Icons.money),
                  const SizedBox(width: 12,),
                  const Text("Online Payment", 
                  style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: 24,),
            ElevatedButton(
  onPressed: () async {
    if (groupValue == 1) {
      Fluttertoast.showToast(
        msg: "Order Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16,
      );
    } else {
      final itemPrice = (widget.item.itemPrice)! * 100;
      bool isSuccessfullyPayment = await Payment.instance.makePayment(itemPrice.toString());
      /* if(isSuccessfullyPayment){
        Fluttertoast.showToast(
         msg: "Payment Success",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         fontSize: 16);
      } */
    }

    // Navigate to ListItems class
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (content) => ItemDetails4(
          user: widget.user, item: widget.item,
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
  child: const Text(
    "Continue",
    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  ),
  // Remove the onPressed here since it is already added in the button onPressed handler above
),

          ],
        ),
      ),
    );
  }
}

/*class CustomRadio extends StatefulWidget {
  final int value;
  final int groupValue;
  final void Function(int)? onChanged;
  const CustomRadio({Key? key, required this.value, required this.groupValue, required this.onChanged })
  : super(key: key);

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    //bool selected = (widget.value == widget.groupValue);

    return Radio(
      value: widget.value, 
      groupValue: widget.groupValue, 
      onChanged: widget.onChanged);
  }
}*/