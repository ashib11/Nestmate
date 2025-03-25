import 'package:flutter/material.dart';
import '../models/property.dart';
import '../screens/details_screen.dart'; // Correct import path // Make sure to import your DetailsScreen

class PropertyCard extends StatelessWidget {
  final Property property;

  PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            property.imageUrl,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.location,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  property.price,
                  style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  property.availability,
                  style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Bedroom: ${property.bedroom} | Bathroom: ${property.bathroom} | Balcony: ${property.balcony} | Kitchen: ${property.kitchen}',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Add message functionality here
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to DetailsScreen when Details button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              title: property.location,
                              price: property.price,
                              availability: property.availability,
                              imageUrl: property.imageUrl,
                              description: property.description, // Make sure your Property model has this field
                              bedrooms: property.bedroom,
                              bathrooms: property.bathroom,
                              balconies: property.balcony,
                              kitchens: property.kitchen,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.deepOrange),
                      onPressed: () {
                        // Add favorite functionality here
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}