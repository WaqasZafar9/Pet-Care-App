import 'package:flutter/material.dart';
import 'package:pet_care/Shoping/category.dart';
import 'package:pet_care/Shoping/newitem.dart';
import 'package:pet_care/Shoping/products.dart';
import 'package:pet_care/slider.dart';

import 'AppBarwidget.dart';

class shopping extends StatefulWidget {
  const shopping({Key? key}) : super(key: key);

  @override
  State<shopping> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<shopping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBarwidget(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.tealAccent,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "What You Want to order?",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.filter_list),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 20, left: 13),
              //   child: Text(
              //     'Top Offers',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 30,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),

              SliderWidget(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              Category(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Popular Items',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              Products(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'New Items',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              newitem(),
              SizedBox(height: 20), // Add additional spacing at the end
            ],
          ),
        ),
      ),
    );
  }
}
