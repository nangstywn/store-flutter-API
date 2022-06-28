import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map product;

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Column(
        children: [
          Container(
            child: Image.network(product['image_url']),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product['price'],
                  style: TextStyle(fontSize: 22),
                ),
                Row(
                  children: [Icon(Icons.edit), Icon(Icons.delete)],
                )
              ],
            ),
          ),
          Text(product['description'])
        ],
      ),
    );
  }
}
