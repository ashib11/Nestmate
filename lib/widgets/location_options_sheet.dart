import 'package:flutter/material.dart';

class LocationOptionsSheet extends StatefulWidget {
  final String selectedLocation;

  const LocationOptionsSheet({required this.selectedLocation});

  @override
  _LocationOptionsSheetState createState() => _LocationOptionsSheetState();
}

class _LocationOptionsSheetState extends State<LocationOptionsSheet> {
  late String selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    final locations = [
      "All",
      // Northern Dhaka
      "Uttara",
      "Tongi",
      "Ashkona",
      "Airport",
      "Khilkhet",
      "Baridhara",
      "Bashundhara",
      "Joar Sahara",
      "Cantonment",

      // Central Dhaka
      "Dhanmondi",
      "Gulshan",
      "Banani",
      "Tejgaon",
      "Farmgate",
      "Mohammadpur",
      "Shyamoli",
      "Adabor",
      "Lalmatia",
      "Green Road",
      "Moghbazar",
      "Eskaton",
      "Malibagh",
      "Rampura",
      "Khilgaon",
      "Banasree",
      "Shantinagar",
      "Motijheel",
      "Paltan",
      "Kakrail",
      "Segunbagicha",

      // Southern Dhaka
      "Wari",
      "Jatrabari",
      "Sadarghat",
      "Keraniganj",
      "Kamrangirchar",
      "Demra",
      "Postogola",
      "Gendaria",
      "Narayanganj",

      // Western Dhaka
      "Hazaribagh",
      "Kamrangirchar",
      "Gabtoli",
      "Rayer Bazar",
      "Beribadh",

      // Eastern Dhaka
      "Badda",
      "Aftabnagar",
      "Merul Badda",
      "Kuratoli",
      "Nadda",

      // Others
      "Agargaon",
      "Mirpur 1",
      "Mirpur 2",
      "Mirpur 10",
      "Mirpur 11",
      "Mirpur 12",
      "Pallabi",
      "Kazipara",
      "Shewrapara",
      "Monipur",
      "Dhaka University Area",
      "Science Lab",
      "New Market",
      "Nilkhet",
      "Taltola",
      "Arambagh",
      "Nazira Bazar",
      "Chawk Bazar",
      "Bangshal",
      "Shyampur",
      "Dayaganj",
      "Dholaikhal",
      "Nimtoli",
      "Kotwali"
    ];;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Text(
                "Select Location",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(width: 48),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return RadioListTile<String>(
                  title: Text(location),
                  value: location,
                  groupValue: selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value!;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context, selectedLocation);
            },
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}