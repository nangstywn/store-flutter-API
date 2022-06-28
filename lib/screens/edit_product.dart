import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class EditProduct extends StatelessWidget {
  final Map product;
  EditProduct({required this.product});
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  Future updateProduct() async {
    final response = await http.put(
        Uri.parse('https://star-store-api.herokuapp.com/api/products/' +
            product['id'].toString()),
        body: {
          'name': _nameController.text,
          'desc': _descriptionController.text,
          'price': _priceController.text,
          'image_url': _imageUrlController.text,
        });
    print(response.body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameController..text = product['name'],
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter product name";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _descriptionController
                  ..text = product['description'],
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter description";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _priceController..text = product['price'],
                decoration: InputDecoration(labelText: "Price"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter price";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _imageUrlController..text = product['image_url'],
                decoration: InputDecoration(labelText: "Image url"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter image url";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateProduct().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Product berhasil di update')));
                    });
                  }
                },
                child: Text("Update")),
          ],
        ),
      ),
    );
  }
}
