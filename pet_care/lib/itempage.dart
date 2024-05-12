import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'AppBarwidget.dart';
import 'cartpage.dart';

class itempage extends StatefulWidget {
  final String productName;
  final String productImage;
  final String? productDescription;
  final double itemPrice;

  const itempage({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.productDescription,
    required this.itemPrice,
  }) : super(key: key);

  @override
  State<itempage> createState() => _ItemPageState();
}

class _ItemPageState extends State<itempage> {
  int itemCount = 1;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    totalPrice = widget.itemPrice;
  }

  void increaseItemCount() {
    setState(() {
      itemCount++;
      totalPrice = itemCount * widget.itemPrice;
    });
  }

  void decreaseItemCount() {
    setState(() {
      if (itemCount > 1) {
        itemCount--;
        totalPrice = itemCount * widget.itemPrice;
      }
    });
  }

  void addToOrderList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => cartpage(newItem: {
          'name': widget.productName,
          'description': widget.productDescription??'',
          'price': widget.itemPrice,
          'quantity': 1,
          'image': widget.productImage,
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: ListView(
          children: [
            AppBarwidget(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                widget.productImage,
                height: 400,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          initialRating: 4,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 18,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.redAccent,
                          ),
                          onRatingUpdate: (index) {},
                        ),
                        Text(
                          '\$${widget.itemPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: decreaseItemCount,
                          child: const Icon(Icons.remove_circle_outline),
                        ),
                        const SizedBox(width: 10),
                        Text('$itemCount'),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: increaseItemCount,
                          child: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.productDescription ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Delivery Time:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          '30 Minutes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300],
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
               ElevatedButton(
                onPressed: addToOrderList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Order Now',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
