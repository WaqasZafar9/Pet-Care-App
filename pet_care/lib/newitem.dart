import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'itempage.dart';

class newitem extends StatefulWidget {
  const newitem({Key? key}) : super(key: key);

  @override
  State<newitem> createState() => _newitemState();
}

class _newitemState extends State<newitem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              // Product 1
              buildProductItem(
                productName: 'Bakers Complete Adult Dog with Chicken & Veg 5kg',
                productImage: 'lib/images/product5.jpg',
                productPrice: 10,
              ),
              SizedBox(height: 8),
              // Product 2
              buildProductItem(
                productName: 'Bakers Complete Adult Dog with Chicken & Veg 5kg',
                productImage: 'lib/images/product1.png',
                productPrice: 10,
              ),
              SizedBox(height: 8),
              // Product 3
              buildProductItem(
                productName: 'Bakers Complete Adult Dog with Chicken & Veg 5kg',
                productImage: 'lib/images/product2.jpg',
                productPrice: 10,
              ),
              SizedBox(height: 8),
              // Product 4
              buildProductItem(
                productName: 'Bakers Complete Adult Dog with Chicken & Veg 5kg',
                productImage: 'lib/images/product3.jpg',
                productPrice: 10,
              ),
              SizedBox(height: 8),
              // Product 5
              buildProductItem(
                productName: 'Bakers Complete Adult Dog with Chicken & Veg 5kg',
                productImage: 'lib/images/product4.jpg',
                productPrice: 10,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductItem({
    required String productName,
    required String productImage,
    required double productPrice,
  }) {
    return Container(
      width: double.infinity,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "itempage");
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3, // Adjusted width
              height: 150,
              alignment: Alignment.center,
              child: Image.asset(
                productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Bakers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    productName,
                    style: TextStyle(fontSize: 15),
                  ),
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 18,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.redAccent,
                    ),
                    onRatingUpdate: (index) {},
                  ),
                  Text(
                    "\$$productPrice",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon(
                //   Icons.favorite_border,
                //   color: Colors.redAccent,
                //   size: 26,
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => itempage(
                          productName: "Baker",
                          productImage: productImage,
                          productDescription:
                          'The Bakers® Story Our story begins way back in 1851 when Edward Baker set up a family flour business. Fast forward to 1991 when Bakers® Complete was launched, because Edward Baker believed that dry dog food should be every bit as tasty as it is nutritious',
                          itemPrice: productPrice,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.redAccent,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
