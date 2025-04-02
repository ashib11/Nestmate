import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import '../widgets/property_card.dart';
import '../models/property.dart';
import '../providers/favorites_provider.dart';
import '../widgets/filter_button.dart';
import '../widgets/sort_options_sheet.dart';
import '../widgets/location_options_sheet.dart';
import '../widgets/filter_options_sheet.dart';
import 'login_screen.dart';


class UserHome extends StatefulWidget {
   UserHome({super.key});

  final ChatService _chatService = ChatService();

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String _selectedSort = "Default";
  String _selectedLocation = "All";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: Scaffold(
        body: Column(
          children: [
            _buildFilterButtons(), // Add filter buttons here
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
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    userName: "Ashib",
    userImage: 'assets/aprtmnt1.jpg.jpeg',
    postTime: DateTime.now().subtract(Duration(minutes: 21)),
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
    userName: "Ashib",
    userImage: 'assets/aprtmnt1.jpg.jpeg',
    postTime: DateTime.now().subtract(Duration(minutes: 21)),
  ),
];
