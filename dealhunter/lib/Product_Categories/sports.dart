import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../search.dart';

class SportScreen extends StatefulWidget {
  @override
  _SportScreenState createState() => _SportScreenState();
}

class _SportScreenState extends State<SportScreen> {
  List<Map<String, dynamic>> groceriesList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  TextEditingController _productController = TextEditingController();
  void _navigateToSearchResults(BuildContext context, String productName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(productName),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.214.223:3000/search-amazon-clothing'));
      print('API Response: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          groceriesList = List<Map<String, dynamic>>.from(data['products']);
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {

      print('Error fetching data: $error');
    }
  }

  Widget productCard(Map<String, dynamic> product) {
    final title = product['title'] as String? ?? 'No Title';
    final price = (product['price'] as String?)?.isEmpty ?? true
        ? 'No Price'
        : product['price'];
    final imageUrl = product['imageUrl'] as String? ??
        'https://via.placeholder.com/150'; // Placeholder URL

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.network(
              imageUrl,
              height: 100.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : 'No Title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  price.isNotEmpty ? price : 'No Price',
                  style: TextStyle(
                    color: Colors.green, // Adjust the color as needed
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groceries'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5,right: 5,bottom: 10),
                    child: TextField(
                      controller: _productController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Search your Product',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: ElevatedButton(
                          onPressed: () {
                            final productName = _productController.text.trim();
                            if (productName.isNotEmpty) {
                              _navigateToSearchResults(context, productName);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 8.0, 
                mainAxisSpacing: 8.0, 
              ),
              itemCount: groceriesList.length,
              itemBuilder: (context, index) {
                final product = groceriesList[index];
                return productCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
