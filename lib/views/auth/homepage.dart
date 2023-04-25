import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/components/reusable_primary_button.dart';
import 'package:foodapp/controllers/auth_controllers.dart';

import '../../models/food_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = AuthController();
  final CollectionReference foodItemsCollection =
  FirebaseFirestore.instance.collection('foodItems');

  String _searchText = ''; // Store the search text entered by the user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform search when the search icon is pressed
              _performSearch();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                // Update the search text as the user types
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by title',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: foodItemsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<FoodItem> foodItems = snapshot.data!.docs
                      .map((doc) =>
                      FoodItem.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  // Filter the food items based on the search text
                  if (_searchText.isNotEmpty) {
                    foodItems = foodItems
                        .where((foodItem) =>
                        foodItem.name.toLowerCase().contains(_searchText.toLowerCase()))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      FoodItem foodItem = foodItems[index];
                      return ListTile(
                        title: Text(foodItem.name),
                        subtitle: Text(foodItem.description),
                        trailing: Text('\R${foodItem.price}'),
                        // Display the image using the Image.network() widget
                        leading: Image.network(foodItem.imageUrl),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ReusablePrimaryButton(
        buttonText: 'Logout',
        onTap: () {
          authController.logoutUser();
        },
      ),
    );
  }

  void _performSearch() {
    // Perform search logic here, if needed
    print('Search text: $_searchText');
  }
}
