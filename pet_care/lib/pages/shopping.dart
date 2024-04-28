import 'package:flutter/material.dart';
import 'package:login_page_practice/pages/products.dart';
import 'package:login_page_practice/pages/slider.dart';

import 'AppBarwidget.dart';
import 'category.dart';
import 'newitem.dart';

class shopping extends StatefulWidget {
  const shopping({super.key});

  @override
  State<shopping> createState() => _shoppingState();
}

class _shoppingState extends State<shopping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: ListView(
          children: [
            AppBarwidget(),
            // seach barr
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.tealAccent,
                      ),
                      Container(
                        height: 50,
                        width: 300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "What You Want to order?",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.filter_list),
                    ],
                  ),
                ),
              ),
            ),

            // category
            Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: Text(
                  'Top Offers',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )),
            SizedBox(
              height: 10,
            ),
            SliderWidget(),
            //SizedBox(height: 5,),
            // category
            Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: Text(
                  'Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )),
            Category(),
            Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: Text(
                  'Populer Items',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )),
            SizedBox(
              height: 5,
            ),
            Products(),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: Text(
                  'New Items',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                )),
            newitem(),
          ],
        ),
       // drawer: Drawer(),
      ),
    );
  }
}
