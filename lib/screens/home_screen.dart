import 'package:flutter/material.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_button.dart';
import '../widgets/sort_options_sheet.dart';
import '../widgets/location_options_sheet.dart';
import '../widgets/filter_options_sheet.dart';
import '../models/property.dart';
import 'category_selection.dart';
import 'inbox_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedSort = "Newest";
  String _selectedLocation = "All";

  // Screens for each tab (excluding Add which uses navigation)
  final List<Widget> _tabScreens = [
    HomeContentScreen(),          // Index 0 - Home
    Container(color: Colors.white, child: Center(child: Text('Search Screen'))), // Index 1 - Search
    FavoritesScreen(),            // Index 2 - Favorites
    ProfileScreen(),              // Index 3 - Profile
  ];

  void _onItemTapped(int index) {
    if (index == 2) { // Add button (index 2)
      // Navigate to CategorySelection and reset to Home when done
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySelectionPage()),
      ).then((_) => setState(() => _selectedIndex = 0));
      return;
    }

    // Handle other tabs (Home, Search, Favorites, Profile)
    setState(() {
      // Adjust index for the missing Add tab in _tabScreens
      _selectedIndex = index >= 3 ? index - 1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      body: _tabScreens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex == 3 ? 4 : _selectedIndex == 2 ? 3 : _selectedIndex,
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
}

class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  String _selectedSort = "Newest";
  String _selectedLocation = "All";

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
      userName: 'Sadia Sultana Enami',
      userImage: 'assets/profile1.jpg',
      postTime: DateTime.now().subtract(Duration(minutes: 21)),
      description: 'A cozy 1-bedroom apartment with a balcony, modern kitchen, and attached bathroom.',
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
      userName: 'Tamanna Alam Tabashom',
      userImage: 'assets/profile2.jpg',
      postTime: DateTime.now().subtract(Duration(hours: 2, minutes: 45)),
      description: 'Spacious 2-bedroom apartment with great ventilation and security.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterButtons(),
        Expanded(
          child: ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _buildUserInfo(properties[index]),
                  PropertyCard(property: properties[index]),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(Property property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(property.userImage),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatTime(property.postTime),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  String _formatTime(DateTime postTime) {
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      final hour = postTime.hour > 12 ? postTime.hour - 12 : postTime.hour;
      final period = postTime.hour < 12 ? 'am' : 'pm';
      final minute = postTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute$period';
    }
  }

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

  Future<String?> showSortOptions(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
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
      shape: RoundedRectangleBorder(
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return FilterOptionsSheet();
      },
    );
  }
}