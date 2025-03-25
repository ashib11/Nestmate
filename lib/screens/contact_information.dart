import 'package:flutter/material.dart';

class ContactInformationPage extends StatefulWidget {
  @override
  _ContactInformationPageState createState() => _ContactInformationPageState();
}

class _ContactInformationPageState extends State<ContactInformationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool otpSent = false;  // Boolean flag to check if OTP is sent

  // Function to simulate sending an OTP
  void _sendOTP() {
    // Check if the phone number entered is 11 digits
    if (_phoneController.text.length == 11) {
      setState(() {
        otpSent = true;  // Set the flag to true when OTP is sent
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("OTP Sent Successfully!")));
    } else {
      // Show error if phone number is not valid
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter a valid 11-digit phone number")));
    }
  }

  // Function to simulate submitting the post after OTP verification
  void _submitPost() {
    if (_otpController.text == "1234") { // Check if the OTP entered is correct
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Post Submitted Successfully!")));
      Navigator.popUntil(context, (route) => route.isFirst);  // Navigate back to the first screen
    } else {
      // Show error if the OTP is invalid
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Information", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,  // Set icon and text color to white
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Full Name Input Field
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person, color: Colors.green),  // Icon for name field
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Phone Number Input Field
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 11, // Limit phone number to 11 digits
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone, color: Colors.green),  // Icon for phone field
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // OTP Input (Visible only when OTP is sent)
                    if (otpSent)  // Check if OTP has been sent, then show OTP input field
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter OTP",
                          prefixIcon: Icon(Icons.lock, color: Colors.green),  // Icon for OTP field
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Button to either send OTP or submit the post
            ElevatedButton(
              onPressed: otpSent ? _submitPost : _sendOTP,  // Conditionally call _sendOTP or _submitPost
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                otpSent ? "Submit Post" : "Send OTP",  // Change button text based on OTP status
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
