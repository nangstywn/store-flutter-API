import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toko_online/screens/add_product.dart';
import 'package:toko_online/screens/edit_product.dart';
import 'package:toko_online/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final String url = "http://10.0.2.2:8000/api/products";
  final int amount = 2700000;
  final String url = "http://star-store-api.herokuapp.com/api/products";

  Future getProducts() async {
    var response = await http.get(Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteProduct(String productId) async {
    String url =
        "http://star-store-api.herokuapp.com/api/products/" + productId;
    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Center(child: Text("Nang Store")),
        ),
        body: FutureBuilder(
            future: getProducts(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data['data'].length,
                    itemBuilder: (context, index) {
                      double uang = double.parse(
                          snapshot.data['data'][index]['price'].toString());
                      return Container(
                        height: 120,
                        child: Card(
                          elevation: 5,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                                product: snapshot.data['data']
                                                    [index],
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  padding: EdgeInsets.all(5),
                                  height: 120,
                                  width: 120,
                                  child: Image.network(snapshot.data['data']
                                      [index]['image_url']),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data['data'][index]['name'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(snapshot.data['data'][index]
                                            ['description']),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditProduct(
                                                                      product: snapshot
                                                                              .data['data']
                                                                          [
                                                                          index],
                                                                    )));
                                                  },
                                                  child: Icon(Icons.edit)),
                                              GestureDetector(
                                                  onTap: () {
                                                    deleteProduct(snapshot
                                                            .data['data'][index]
                                                                ['id']
                                                            .toString())
                                                        .then((value) {
                                                      setState(() {});
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'Product berhasil dihapus')));
                                                    });
                                                  },
                                                  child: Icon(Icons.delete)),
                                            ],
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'id',
                                                    decimalDigits: 0,
                                                    symbol: 'Rp ')
                                                .format(uang),
                                            // snapshot.data['data'][index]
                                            //     ['price'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
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
                      );
                    });
              } else {
                return Text('Data error');
              }
            }));
  }
}
