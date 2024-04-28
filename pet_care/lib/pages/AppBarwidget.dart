import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page_practice/pages/cartpage.dart';

class AppBarwidget extends StatefulWidget {
  const AppBarwidget({Key? key}) : super(key: key);

  @override
  State<AppBarwidget> createState() => _AppBarwidgetState();
}

class _AppBarwidgetState extends State<AppBarwidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "shopping");
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white70, // Set a color for the container
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0,3),
                )
              ]
              ),
              child: Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ), // Add an icon or any other widget as child
            ),
          ),
          InkWell(
            onTap: () {
                Navigator.pushNamed(context, "cartpage");
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white70, // Set a color for the container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0,3),
                    )
                  ]
              ),
              child: Icon(
                CupertinoIcons.cart_fill,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
