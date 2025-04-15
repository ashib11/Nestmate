import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'property_details.dart';

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {"name": "Family", "icon": Icons.family_restroom, "color": Colors.deepOrange},
    {"name": "Bachelor", "icon": Icons.person, "color": Colors.blue},
    {"name": "Sublet (Male)", "icon": Icons.male, "color": Colors.indigo},
    {"name": "Sublet (Female)", "icon": Icons.female, "color": Colors.pink},
    {"name": "Office/Commercial", "icon": Icons.business, "color": Colors.teal},
  ];

  void _navigateNext() {
    if (selectedCategory != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => PropertyDetailsPage(category: selectedCategory!),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a category")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F8E9),
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Category Selection',
          style: TextStyle(
            color: Color(0xFF388E3C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(28, 28),
          ),
        ),
        toolbarHeight: 56,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                SizedBox(height: 5),
                Lottie.asset(
                  'assets/home.json',
                  height: constraints.maxHeight * 0.18,
                  fit: BoxFit.contain,
                  frameRate: FrameRate(60),
                ),
                SizedBox(height: 10),
                Text(
                  "Choose the property type",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    itemCount: categories.length,
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      bool isSelected = selectedCategory == category["name"];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category["name"];
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green[300] : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? Colors.green : Colors.transparent,
                              width: 2,
                            ),
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
                              AnimatedScale(
                                scale: isSelected ? 1.1 : 1.0,
                                duration: Duration(milliseconds: 200),
                                child: Icon(
                                  category["icon"],
                                  size: 45,
                                  color: category["color"],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _navigateNext,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
