import 'package:flutter/material.dart';
import 'package:pet_care/Shoping/AppBarwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class cartpage extends StatefulWidget {
  final Map<String, dynamic>? newItem; // Make newItem optional

  const cartpage({Key? key, this.newItem}) : super(key: key);

  @override
  State<cartpage> createState() => _CartPageState();
}

class _CartPageState extends State<cartpage> {
  List<Map<String, dynamic>> items = [];
  late SharedPreferences prefs; // SharedPreferences instance

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences(); // Initialize SharedPreferences
    if (widget.newItem != null) {
      items.add(widget.newItem!); // Add newItem to items list if not null
      saveItems(); // Save items to SharedPreferences
    }
    loadItems(); // Load items from SharedPreferences
  }

  void initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();// Initialize SharedPreferences
    loadItems();
  }

  void saveItems() {
    prefs.setStringList('items', items.map((item) => item.toString()).toList());
  }

  void loadItems() {
    if (prefs != null) {
      final List<String>? savedItems = prefs.getStringList('items');
      if (savedItems != null) {
        items = savedItems.map((item) => Map<String, dynamic>.from(json.decode(item))).toList();
      }
    } else {
      print('SharedPreferences is not initialized.');
    }
  }



  double getTotalPrice() {
    double totalPrice = 0.0;
    items.forEach((item) {
      totalPrice += item['price'] * item['quantity'];
    });
    return totalPrice;
  }

  void increaseItemCount(int index) {
    setState(() {
      items[index]['quantity']++;
      saveItems(); // Save items after modification
    });
  }

  void decreaseItemCount(int index) {
    setState(() {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity']--;
        saveItems(); // Save items after modification
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarwidget(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10),
                  child: Text(
                    'ORDER LIST',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                items[index]['image'],
                                height: 80,
                                width: 150,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      items[index]['name'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${items[index]['price'] * items[index]['quantity']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => increaseItemCount(index),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      '${items[index]['quantity']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => decreaseItemCount(index),
                                      child: const Icon(
                                        Icons.minimize,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '${items.fold<int>(0, (prev, item) => prev + item['quantity'] as int)}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub-Total',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '\$${getTotalPrice()}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.black38),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '\$30', // Assuming fixed delivery cost
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${getTotalPrice() + 30}', // Total = Sub-Total + Delivery
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            items.clear(); // Clear the items list
                            saveItems(); // Save empty list to clear SharedPreferences
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.redAccent),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.redAccent),
                        ),
                        child: Text(
                          'Check Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
