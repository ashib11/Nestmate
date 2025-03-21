import 'package:flutter/material.dart';

void main() {
  runApp(NestMateApp());
}

class NestMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedSort = "Newest";
  String _selectedLocation = "All";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Property> properties = [
    Property(
      imageUrl: 'assets/aprtmnt1.jpg.jpeg',
      location: 'Uttara 7 no sector',
      price: '5500 tk / month',
      availability: 'Tolet from May',
      bedroom: 1,
      bathroom: 1,
      balcony: 1,
      kitchen: 1,
    ),
    Property(
      imageUrl: 'assets/aprtmnt2.jpg.jpeg',
      location: 'Dhanmondi 27',
      price: '6500 tk / month',
      availability: 'Tolet from June',
      bedroom: 2,
      bathroom: 2,
      balcony: 1,
      kitchen: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'NestMate',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Icon(Icons.home, color: Colors.green),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.deepOrange),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.message, color: Colors.blue),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterButton(
                    icon: Icons.sort,
                    label: 'Sort ($_selectedSort)',
                    onTap: () async {
                      final result = await showSortOptions(context);
                      if (result != null) {
                        setState(() {
                          _selectedSort = result;
                        });
                      }
                    },
                  ),
                  FilterButton(
                    icon: Icons.filter_list,
                    label: 'Filter',
                    onTap: () async {
                      await showFilterOptions(context);
                    },
                  ),
                  FilterButton(
                    icon: Icons.location_on,
                    label: 'Location ($_selectedLocation)',
                    onTap: () async {
                      final result = await showLocationOptions(context);
                      if (result != null) {
                        setState(() {
                          _selectedLocation = result;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: properties[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Future<String?> showSortOptions(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SortOptionsSheet(selectedSort: _selectedSort);
      },
    );
  }

  Future<String?> showLocationOptions(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return LocationOptionsSheet(selectedLocation: _selectedLocation);
      },
    );
  }

  Future<void> showFilterOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return FilterOptionsSheet();
      },
    );
  }
}

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
    ];

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


class Property {
  final String imageUrl, location, price, availability;
  final int bedroom, bathroom, balcony, kitchen;

  Property({
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.availability,
    required this.bedroom,
    required this.bathroom,
    required this.balcony,
    required this.kitchen,
  });
}

class PropertyCard extends StatelessWidget {
  final Property property;

  PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              property.imageUrl,
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.location, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(property.availability, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(property.price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  FilterButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: TextStyle(color: Colors.black)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class SortOptionsSheet extends StatefulWidget {
  final String selectedSort;

  const SortOptionsSheet({required this.selectedSort});

  @override
  _SortOptionsSheetState createState() => _SortOptionsSheetState();
}

class _SortOptionsSheetState extends State<SortOptionsSheet> {
  late String selectedSort;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
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
                "Sort by",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(width: 48),
            ],
          ),
          buildRadioOption("Newest"),
          buildRadioOption("Price (Low to High)"),
          buildRadioOption("Price (High to Low)"),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context, selectedSort);
            },
            child: const Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildRadioOption(String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: selectedSort,
      onChanged: (value) {
        setState(() {
          selectedSort = value!;
        });
      },
    );
  }
}

class FilterOptionsSheet extends StatefulWidget {
  @override
  _FilterOptionsSheetState createState() => _FilterOptionsSheetState();
}

class _FilterOptionsSheetState extends State<FilterOptionsSheet> {
  String _selectedPropertyType = "Family";
  int _selectedBedrooms = 1;
  int _selectedBathrooms = 1;
  int _selectedBalconies = 1;
  final Set<String> _selectedFacilities = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Filter",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Property Types", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
            buildPropertyTypeOption("Family"),
            buildPropertyTypeOption("Bachelor"),
            buildPropertyTypeOption("Office Space"),
            buildPropertyTypeOption("Subtle Room for Female"),
            buildPropertyTypeOption("Subtle Room for Male"),
            const SizedBox(height: 16),
            const Text("Bedrooms :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
            buildSelectableOptions(1, 5, _selectedBedrooms, (value) {
              setState(() {
                _selectedBedrooms = value;
              });
            }),
            const SizedBox(height: 16),
            const Text("Bathrooms :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
            buildSelectableOptions(1, 5, _selectedBathrooms, (value) {
              setState(() {
                _selectedBathrooms = value;
              });
            }),
            const SizedBox(height: 16),
            const Text("Balconies :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
            buildSelectableOptions(1, 5, _selectedBalconies, (value) {
              setState(() {
                _selectedBalconies = value;
              });
            }),
            const SizedBox(height: 16),
            const Text("Facility & Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
            buildFacilityOption("Lift"),
            buildFacilityOption("Gas"),
            buildFacilityOption("Generator"),
            buildFacilityOption("CCTV"),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPropertyType = "Family";
                      _selectedBedrooms = 1;
                      _selectedBathrooms = 1;
                      _selectedBalconies = 1;
                      _selectedFacilities.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green),
                  ),
                  child: const Text("Reset Filter", style: TextStyle(color: Colors.green)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Apply Filter", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPropertyTypeOption(String type) {
    return RadioListTile<String>(
      title: Text(type),
      value: type,
      groupValue: _selectedPropertyType,
      onChanged: (value) {
        setState(() {
          _selectedPropertyType = value!;
        });
      },
    );
  }

  Widget buildSelectableOptions(int min, int max, int selectedValue, ValueChanged<int> onSelected) {
    return Row(
      children: List.generate(max - min + 1, (index) {
        final value = min + index;
        return GestureDetector(
          onTap: () {
            onSelected(value);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: value == selectedValue ? Colors.green : Colors.grey[200],
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: value == selectedValue ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildFacilityOption(String facility) {
    return CheckboxListTile(
      value: _selectedFacilities.contains(facility),
      title: Text(facility),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedFacilities.add(facility);
          } else {
            _selectedFacilities.remove(facility);
          }
        });
      },
    );
  }
}