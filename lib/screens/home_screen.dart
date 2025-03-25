import 'package:flutter/material.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_button.dart';
import '../widgets/sort_options_sheet.dart';
import '../widgets/location_options_sheet.dart';
import '../widgets/filter_options_sheet.dart';
import '../models/property.dart';
import 'inbox_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterButtons(),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // App Bar
  AppBar _buildAppBar() {
    return AppBar(
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
          icon: Icon(Icons.notifications, color: Colors.blueGrey),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.message, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InboxScreen()),
            );
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }

  // Filter Buttons (Sort, Filter, Location)
  Widget _buildFilterButtons() {
    return Padding(
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
    );
  }

  // Bottom Navigation Bar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  // Show Sort Options Bottom Sheet
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

  // Show Location Options Bottom Sheet
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

  // Show Filter Options Bottom Sheet
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