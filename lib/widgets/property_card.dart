import 'package:flutter/material.dart';
import '../models/property.dart';

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
                  style: TextStyle(fontSize: 16, color: Colors.green,fontWeight: FontWeight.bold),
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
                        backgroundColor: Colors.green, // Set background color to green
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
                        ),
                      ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.white), // Set text color to white
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