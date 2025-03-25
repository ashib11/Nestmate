import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'property_details.dart';

// Stateful widget for category selection page
class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  String? selectedCategory; // Stores the selected category

  // List of categories with name, icon, and color
  final List<Map<String, dynamic>> categories = [
    {"name": "Family", "icon": Icons.family_restroom, "color": Colors.deepOrange},
    {"name": "Bachelor", "icon": Icons.person, "color": Colors.blue},
    {"name": "Sublet (Male)", "icon": Icons.male, "color": Colors.indigo},
    {"name": "Sublet (Female)", "icon": Icons.female, "color": Colors.pink},
    {"name": "Office/Commercial", "icon": Icons.business, "color": Colors.teal},
  ];

  // Function to navigate to the next page if a category is selected
  void _navigateNext() {
    if (selectedCategory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PropertyDetailsPage(category: selectedCategory!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a category")));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsiveness

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      appBar: AppBar(
        title: Text("Select Category", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green, // Green app bar
        iconTheme: IconThemeData(color: Colors.white), // White icons
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            // Lottie animation for visual appeal
            Lottie.asset('assets/home.json', height: 100, frameRate: FrameRate(60)),
            SizedBox(height: 10),
            // Title text for category selection
            Text(
              "Choose the property type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 15),
            // Grid view for category selection
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), // Prevent scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth < 600 ? 2 : 3, // Responsive grid layout
                  childAspectRatio: 1.3, // Adjust aspect ratio for better fit
                  crossAxisSpacing: 10, // Spacing between grid items
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length, // Number of categories
                itemBuilder: (context, index) {
                  var category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category["name"]; // Update selected category
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300), // Smooth animation
                      decoration: BoxDecoration(
                        color: selectedCategory == category["name"] ? Colors.green[300] : Colors.white, // Highlight selection
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category["icon"], size: 45, color: category["color"]), // Category icon
                          SizedBox(height: 6),
                          Text(category["name"],
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), // Category name
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            // Next button to navigate to the property details page
            ElevatedButton(
              onPressed: _navigateNext,
              child: Text("Next", style: TextStyle(
                  color: Colors.white,
                  fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.green, // Green button
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
