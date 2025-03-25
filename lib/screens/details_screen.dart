import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String price;
  final String availability;
  final String imageUrl;
  final String description;
  final int bedrooms;
  final int bathrooms;
  final int balconies;

  DetailsScreen({
    required this.title,
    required this.price,
    required this.availability,
    required this.imageUrl,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
    required this.balconies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Image Section**
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              /// **Price & Availability**
              Text(
                price,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Available from: $availability',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),

              SizedBox(height: 16),

              /// **Property Details (Bedrooms, Bathrooms, etc.)**
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoTile(Icons.bed, 'Bedroom', bedrooms.toString()),
                      _infoTile(Icons.bathtub, 'Bathroom', bathrooms.toString()),
                      _infoTile(Icons.balcony, 'Balcony', balconies.toString()),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// **Description Section**
              Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),

              SizedBox(height: 20),

              /// **Contact Buttons**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.message, color: Colors.green),
                    label: Text('Message', style: TextStyle(color: Colors.green)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.call, color: Colors.orange),
                    label: Text('Call Owner', style: TextStyle(color: Colors.orange)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Helper Method: Info Tile**
  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 28),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}