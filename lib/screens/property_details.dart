import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking functionality
import 'dart:io'; // Import for file handling (image selection)
import 'contact_information.dart'; // Import the next page for navigation

// Define the PropertyDetailsPage as a StatefulWidget
class PropertyDetailsPage extends StatefulWidget {
  final String category; // This will be passed to the page to specify the property category
  PropertyDetailsPage({required this.category});

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

// State class for PropertyDetailsPage
class _PropertyDetailsPageState extends State<PropertyDetailsPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;  // Animation controller for fade animation
  late Animation<double> _fadeAnimation;  // Fade animation to apply to the page content

  File? _selectedImage;  // Variable to hold the selected image file

  // TextEditingController for various form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Variables for property features (e.g. bedrooms, bathrooms, etc.)
  String? _selectedBedrooms;
  String? _selectedBathrooms;
  String? _selectedFurnishing;
  String? _selectedParking;
  String? _selectedBalconies;

  // Variables for property facilities (e.g. lift, gas, generator)
  bool _hasLift = false;
  bool _hasGas = false;
  bool _hasGenerator = false;
  bool _hasCCTV = false;

  // Options for dropdown fields
  final List<String> furnishingOptions = ["Unfurnished", "Semi-Furnished", "Fully Furnished"];
  final List<String> parkingOptions = ["No Parking", "1 Spot", "2 Spots", "More than 2"];
  final List<String> bedroomOptions = ["Studio", "1", "2", "3", "4+"];
  final List<String> bathroomOptions = ["1", "2", "3", "4+"];
  final List<String> balconyOptions = ["None", "1", "2", "3", "4+", "More than 4"];

  // Initialize the fade animation controller
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();  // Start the animation
  }

  // Dispose of the animation controller when the page is disposed
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to pick an image from either gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);  // Save the picked image file
      });
    }
  }

  // Navigate to the next page if all required details are filled
  void _navigateNext() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _sizeController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _selectedBedrooms != null &&
        _selectedBathrooms != null &&
        _selectedFurnishing != null &&
        _selectedParking != null &&
        _selectedBalconies != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ContactInformationPage())); // Navigate to the next page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all details")));  // Show a message if not all fields are filled
    }
  }

  // Helper method to build dropdowns for property features like bedrooms, bathrooms, etc.
  Widget _buildDropdown(String title, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,  // Update the selected value when a new item is selected
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ],
    );
  }

  // Helper method to build checkboxes for facilities like Lift, Gas, etc.
  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Checkbox(
          value: value,
          onChanged: onChanged,  // Update the value when checkbox is clicked
          activeColor: Colors.green,  // Checkbox color when active
          checkColor: Colors.white,  // Color of the check mark
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F8E9),
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Add property details',
          style: TextStyle(
            color: Color(0xFF388E3C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            // top: Radius.circular(28),
              top: Radius.elliptical(28, 28)
          ),
        ),
        toolbarHeight: 56,
      ),
      body: FadeTransition(  // Apply fade animation to the body of the page
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(  // Allows scrolling if the content overflows
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      // Display selected image or a placeholder icon
                      _selectedImage != null
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover))
                          : Icon(Icons.image, size: 80, color: Colors.grey),
                      SizedBox(height: 10),
                      Row(  // Row to place gallery and camera buttons next to each other
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button to pick image from gallery
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: Icon(Icons.photo, color: Colors.white),
                            label: Text("Gallery"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),
                          SizedBox(width: 10),
                          // Button to pick image from camera
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            label: Text("Camera"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Input fields for title, description, price, size, and location
                TextField(controller: _titleController, decoration: InputDecoration(labelText: "Title")),
                SizedBox(height: 15),
                TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
                SizedBox(height: 15),
                TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Price (BDT)")),
                SizedBox(height: 15),
                TextField(controller: _sizeController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Size (sq. ft.)")),
                SizedBox(height: 15),
                TextField(controller: _locationController, decoration: InputDecoration(labelText: "Location")),
                SizedBox(height: 15),

                // Dropdowns for bedroom, bathroom, balcony, furnishing, and parking options
                _buildDropdown("Bedrooms", bedroomOptions, _selectedBedrooms, (value) => setState(() => _selectedBedrooms = value)),
                SizedBox(height: 15),
                _buildDropdown("Balconies", balconyOptions, _selectedBalconies, (value) => setState(() => _selectedBalconies = value)),
                SizedBox(height: 20),
                _buildDropdown("Bathrooms", bathroomOptions, _selectedBathrooms, (value) => setState(() => _selectedBathrooms = value)),
                SizedBox(height: 15),
                _buildDropdown("Furnishing", furnishingOptions, _selectedFurnishing, (value) => setState(() => _selectedFurnishing = value)),
                SizedBox(height: 15),
                _buildDropdown("Parking", parkingOptions, _selectedParking, (value) => setState(() => _selectedParking = value)),
                SizedBox(height: 20),

                // Facilities and services section with checkboxes
                Text("Facilities and Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                _buildCheckbox("Lift", _hasLift, (value) => setState(() => _hasLift = value!)),
                _buildCheckbox("Gas", _hasGas, (value) => setState(() => _hasGas = value!)),
                _buildCheckbox("Generator", _hasGenerator, (value) => setState(() => _hasGenerator = value!)),
                _buildCheckbox("CCTV", _hasCCTV, (value) => setState(() => _hasCCTV = value!)),

                SizedBox(height: 15),

                // Button to navigate to the next page
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateNext,  // Trigger next page navigation
                    child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
