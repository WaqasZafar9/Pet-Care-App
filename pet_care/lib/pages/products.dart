import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SafeArea(
        child: Row(
          children: [
           // for(int i=0; i<5; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 150,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap the image with a container and set a fixed height
                      Container(
                        height: 150, // Set a fixed height for the image
                        alignment: Alignment.center,
                        child: ClipRRect(
                          // Clip overflowing parts of the image
                          borderRadius: BorderRadius.circular(10), // Maintain rounded corners
                          child: Image.asset(
                            'lib/images/catproduct1.jpg',
                            fit: BoxFit.cover, // Scale image to fit container
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fluffy Product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'New Fluffy Material For Cats',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$10',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 150,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap the image with a container and set a fixed height
                      Container(
                        height: 150, // Set a fixed height for the image
                        alignment: Alignment.center,
                        child: ClipRRect(
                          // Clip overflowing parts of the image
                          borderRadius: BorderRadius.circular(10), // Maintain rounded corners
                          child: Image.asset(
                            'lib/images/product4.jpg',
                            fit: BoxFit.cover, // Scale image to fit container
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fluffy Product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'New Fluffy Material For Cats',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$10',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 150,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap the image with a container and set a fixed height
                      Container(
                        height: 150, // Set a fixed height for the image
                        alignment: Alignment.center,
                        child: ClipRRect(
                          // Clip overflowing parts of the image
                          borderRadius: BorderRadius.circular(10), // Maintain rounded corners
                          child: Image.asset(
                            'lib/images/product5.jpg',
                            fit: BoxFit.cover, // Scale image to fit container
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fluffy Product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'New Fluffy Material For Cats',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$10',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 150,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap the image with a container and set a fixed height
                      Container(
                        height: 150, // Set a fixed height for the image
                        alignment: Alignment.center,
                        child: ClipRRect(
                          // Clip overflowing parts of the image
                          borderRadius: BorderRadius.circular(10), // Maintain rounded corners
                          child: Image.asset(
                            'lib/images/product3.jpg',
                            fit: BoxFit.cover, // Scale image to fit container
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fluffy Product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'New Fluffy Material For Cats',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$10',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
