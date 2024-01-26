import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'search.dart';
import 'Product_Categories/books.dart';
import 'Product_Categories/clothing.dart';
import 'Product_Categories/electronics.dart';
import 'Product_Categories/furniture.dart';
import 'Product_Categories/groceries.dart';
import 'Product_Categories/sports.dart';
import 'Product_Categories/toy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMore = false;

  void _toggleShowMore() {
    setState(() {
      _showMore = !_showMore;
    });
  }

  TextEditingController _productController = TextEditingController();
  void _navigateToSearchResults(BuildContext context, String productName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(productName),
      ),
    );
  }

  List<String> imageUrls = [
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
    'assets/watch.jpg',
  ];

  List<Map<String, dynamic>> groceriesList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.214.223:3000/search-amazon-clothing'));
      print('API Response: ${response.body}');

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          groceriesList = List<Map<String, dynamic>>.from(data['products']);
        });
      } else {
        // Handle error or unexpected content type
        print('Error: Unexpected or invalid response format');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        shadowColor: Colors.black,
        title: const Text(
          '🅳🅴🅰🅻🅷🆄🅽🆃🅴🆁',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 110, 91, 230),
                size: 44,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 110, 91, 230),
              ),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 70,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Drawer Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black45)),
              child: ListTile(
                title: Text('Start'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle drawer item click
                },
              ),
            ),
            Container(
              child: ListTile(
                title: Text('Sale'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle drawer item click
                },
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black45)),
              child: ListTile(
                title: Text('How to use'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle drawer item click
                },
              ),
            ),
            Container(
              child: ListTile(
                title: Text('Log out'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle drawer item click
                },
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black45)),
              child: ListTile(
                title: Text('About us'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle drawer item click
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 115,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 110, 91, 230),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
                child: Column(
                  children: [
                    const Text(
                      'Compare Price of different products',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: _productController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
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
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: ElevatedButton(
                                    onPressed: () {
                                      final productName =
                                          _productController.text.trim();
                                      if (productName.isNotEmpty) {
                                        _navigateToSearchResults(
                                            context, productName);
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
                  ],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.0,
              ),
              items: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Center(
                        child: Image.asset(
                      'assets/Flipkart.webp',
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Center(
                        child: Image.asset(
                      'assets/Amazon.jpg',
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Center(
                        child: Image.asset(
                      'assets/amazon-prime.webp',
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 10, bottom: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose Categories',
                    style: TextStyle(
                        color: Color.fromARGB(255, 110, 91, 230),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            CustomListView(_showMore),
            ElevatedButton(
              onPressed: _toggleShowMore,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 4,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              child: Text(
                _showMore ? 'Show Less' : 'Show More',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Top Searches',
                style: TextStyle(
                    color: Color.fromARGB(255, 110, 91, 230),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(10, (index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            image: DecorationImage(
                              image: AssetImage(imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Watch'),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                'Top Products',
                style: TextStyle(
                    color: Color.fromARGB(255, 110, 91, 230),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(
                (groceriesList.length / 2).ceil(),
                (rowIndex) {
                  final int firstIndex = rowIndex * 2;
                  final int secondIndex = firstIndex + 1;
        
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: productCard(groceriesList[firstIndex]),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: secondIndex < groceriesList.length
                              ? productCard(groceriesList[secondIndex])
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}


// class CustomListView extends StatelessWidget {
//   final bool showMore;

//   CustomListView(this.showMore);
//   final List<String> itemNames = [
//     'Electronics',
//     'Groceries',
//     'Clothing',
//     'Furniture',
//     'Books',
//     'Toys',
//     'Sports'
//   ];

//   // Define your API endpoints for each itemName
//   Map<String, String> apiEndpoints = {
//     'Electronics': '/search-amazon-electronics',
//     'Groceries': '/search-amazon-groceries',
//     'Clothing': '/search-amazon-clothing',
//     'Furniture': '/search-amazon-furniture',
//     'Books': '/search-amazon-books',
//     'Toys': '/search-amazon-toys',
//     'Sports': '/search-amazon-sports',
//   };

//   void _onItemTap(BuildContext context, String itemName) async {
//     try {
//       final response = await http.get('');
//       if (response.statusCode == 200) {
//         print('$itemName API response: ${response.body}');
//       } else {
//         print('Error fetching $itemName API: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching $itemName API: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: showMore ? 7 : 4,
//       itemBuilder: (BuildContext context, int index) {
//         final itemName = itemNames[index % itemNames.length];
//         return SizedBox(
//           height: 60,
//           child: GestureDetector(
//             onTap: () => _onItemTap(context, itemName),
//             child: Card(
//               elevation: 2,
//               shadowColor: Colors.black.withOpacity(0.5),
//               margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//               child: ListTile(
//                 title: Text(itemName),
//                 trailing: const Icon(
//                   Icons.arrow_forward,
//                   color: Color.fromARGB(255, 110, 91, 230),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class CustomListView extends StatelessWidget {
  final bool showMore;

  CustomListView(this.showMore);

  final List<String> itemNames = [
    'Electronics',
    'Groceries',
    'Clothing',
    'Furniture',
    'Books',
    'Toys',
    'Sports'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: showMore ? 7 : 4,
      itemBuilder: (BuildContext context, int index) {
        final itemName = itemNames[index % itemNames.length];
        return SizedBox(
          height: 60,
          child: GestureDetector(
            onTap: () {
              // Navigate to respective screen based on the selected item
              switch (itemName) {
                case 'Electronics':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ElectronicsScreen()),
                  );
                  break;
                case 'Clothing':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClothingScreen()),
                  );
                  break;
                case 'Furniture':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FurnitureScreen()),
                  );
                  break;
                case 'Books':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BooksScreen()),
                  );
                  break;
                case 'Toys':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToysScreen()),
                  );
                  break;
                case 'Sports':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SportScreen()),
                  );
                  break;
                case 'Groceries':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroceriesScreen()),
                  );
                  break;
              }
            },
            child: Card(
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.5),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                title: Text(itemName),
                trailing: const Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(255, 110, 91, 230),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


Widget productCard(Map<String, dynamic> product) {
  final title = product['title'] as String? ?? 'No Title';
  final price = (product['price'] as String?)?.isEmpty ?? true
      ? 'No Price'
      : product['price'];
  final imageUrl = product['imageUrl'] as String? ??
      'https://placeholder.com/150'; 

  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          imageUrl,
          height: 120.0,
          width: double.infinity,
          fit: BoxFit.cover,
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(price.isNotEmpty ? price : 'No Price'),
            ],
          ),
        ),
      ],
    ),
  );
}
