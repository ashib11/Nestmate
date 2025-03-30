import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String? currentImage;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileScreen({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.onSave,
    this.currentImage,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late String _selectedGender;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _selectedGender = widget.gender.isNotEmpty ? widget.gender : 'Male';
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Profile Picture"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<String?> uploadProfilePicture(File imageFile) async {
    const cloudName = "dvhjmuku7";
    const uploadPreset = "profile_pic_upload";

    final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
    final request = http.MultipartRequest("POST", Uri.parse(url))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      return responseData['secure_url'];
    }
    return null;
  }

  void _saveProfile() async {
    if (_firstNameController.text.trim().length < 3 ||
        _lastNameController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name must be at least 3 characters long.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    final uid = user.uid;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    String? imageUrl;

    try {
      if (_profileImage != null) {
        imageUrl = await uploadProfilePicture(_profileImage!);
        if (imageUrl == null) throw Exception("Image upload failed");
      }

      final updatedData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'gender': _selectedGender,
        'profileImageUrl': imageUrl ?? widget.currentImage,
      };

      await userDocRef.set(updatedData, SetOptions(merge: true));
      widget.onSave(updatedData);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: ClipOval(
                          child: _profileImage != null
                              ? Image.file(_profileImage!, fit: BoxFit.cover)
                              : (widget.currentImage?.isNotEmpty == true
                              ? Image.network(
                            widget.currentImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Show error icon if image fails to load
                              return Icon(Icons.error, color: Colors.red);
                            },
                          )
                              : Icon(Icons.person, size: 60, color: Colors.green[800]))
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildFormFields(),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(_firstNameController, 'First Name', Icons.person),
        const SizedBox(height: 15),
        _buildTextField(_lastNameController, 'Last Name', Icons.person),
        const SizedBox(height: 15),
        _buildTextField(_emailController, 'Email', Icons.email, enabled: false),
        const SizedBox(height: 15),
        _buildTextField(_phoneController, 'Phone Number', Icons.phone),
        const SizedBox(height: 15),
        _buildGenderDropdown(),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool enabled = true,
      }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.transgender, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'SAVE CHANGES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}