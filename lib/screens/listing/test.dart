// Expanded(
//                   child: GridView.count(
//                         (index) {
//                           return Card(
//                             child: InkWell(
//                               child: Column(children: [
//                                 CachedNetworkImage(

//                                   height: 97,
//                                   //width: 100,
//                                   fit: BoxFit.fitWidth,
//                                   imageUrl:
//                                       "${MyConfig().SERVER}/barter_it2/assets/items/${catchList[index].itemId}_1.png",
//                                   placeholder: (context, url) =>
//                                       const LinearProgressIndicator(),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(Icons.error),
//                                 ),
//                                 Text(
//                                   catchList[index].itemName.toString(),
//                                   style: const TextStyle(fontSize: 17, color: Colors.black),
//                                 ),
//                                 Text(
//                                   "RM ${double.parse(catchList[index].itemPrice.toString()).toStringAsFixed(2)}",
//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                                 Text(
//                                   "${catchList[index].itemQty} available",
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ]),
//                             ),
//                           );
//                         },
//                       )),