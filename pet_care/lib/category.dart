import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String selectedCategory = 'cat'; // Default selected category

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              SizedBox(width: 10), // Add initial padding
              buildCategoryItem('Cat', 'cat', 'lib/images/cat1.png'),
              SizedBox(width: 10), // Add space between items
              buildCategoryItem('Dog', 'dog', 'lib/images/dog1.png'),
              SizedBox(width: 10), // Add space at the end
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItem(String categoryName, String categoryValue, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryValue;
        });
        // Add logic to open respective products page based on selected category
        // For example:
        // if (categoryValue == 'cat') {
        //   Navigator.pushNamed(context, 'catProducts');
        // } else if (categoryValue == 'dog') {
        //   Navigator.pushNamed(context, 'dogProducts');
        // }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: 150,
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: selectedCategory == categoryValue ? Colors.tealAccent : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Image.asset(
              imagePath,
              width: 150,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}
