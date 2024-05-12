import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product {
  final String image;
  final String title;
  final String description;
  final double price;

  Product({
    required this.image,
    required this.title,
    required this.description,
    required this.price,
  });
}

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> productList = [
    Product(
      image: 'assets/images/catproduct1.jpg',
      title: 'Fluffy Product',
      description: 'New Fluffy Material For Cats',
      price: 10.0,
    ),
    Product(
      image: 'assets/images/catproduct1.jpg',
      title: 'Fluffy Product',
      description: 'New Fluffy Material For Cats',
      price: 10.0,
    ),
    Product(
      image: 'assets/images/catproduct1.jpg',
      title: 'Fluffy Product',
      description: 'New Fluffy Material For Cats',
      price: 10.0,
    ),
    Product(
      image: 'assets/images/catproduct1.jpg',
      title: 'Fluffy Product',
      description: 'New Fluffy Material For Cats',
      price: 10.0,
    ),
    Product(
      image: 'assets/images/catproduct1.jpg',
      title: 'Fluffy Product',
      description: 'New Fluffy Material For Cats',
      price: 10.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SafeArea(
        child: Row(
          children: productList.map((product) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.2, // Adjust aspect ratio for responsiveness
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.description,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price}',
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
