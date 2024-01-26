import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


class SearchResultsPage extends StatefulWidget {
  final String productName;

  SearchResultsPage(this.productName);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.214.223:3000/compare/${widget.productName}'),
      );
      print('API Response: ${response.body}');

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null && data.containsKey('products')) {
          setState(() {
            searchResults =
                List<Map<String, dynamic>>.from(data['products'] ?? []);
          });
        } else {
          // Handle missing 'products' key or null data
          print('Error: Missing key or null data in the response');
        }
      } else {
        // Handle error or unexpected content type
        print('Error: Unexpected or invalid response format');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error fetching search results: $error');
    }


  setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                final title = result['title'] as String? ?? 'No Title';
                final price = result['price'] as String? ?? 'No Price';
                final imageUrl =
                    result['imageUrl'] as String? ?? '';
                final source = result['source'] as String? ?? 'Unknown Source';

                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(price),
                      Text('Source: $source'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
