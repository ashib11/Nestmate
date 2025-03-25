import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = "Relevance";
  String _selectedLocation = "All";
  String _selectedPriceRange = "Any";
  String _selectedBedrooms = "Any";
  bool _showFilters = false;

  // Sample property data - fixed syntax
  final List<Property> _allProperties = [
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
    ),

  ];

  List<Property> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _filteredProperties = _allProperties;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProperties =
          _allProperties.where((property) {
            final locationMatch = property.location.toLowerCase().contains(
              query,
            );
            final priceMatch = property.price.toLowerCase().contains(query);
            final bedroomMatch = property.bedroom.toString().contains(query);
            return locationMatch || priceMatch || bedroomMatch;
          }).toList();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredProperties =
          _allProperties.where((property) {
            bool locationMatch =
                _selectedLocation == "All" ||
                property.location.contains(_selectedLocation);
            bool priceMatch = true; // price range logic
            bool bedroomMatch =
                _selectedBedrooms == "Any" ||
                property.bedroom == int.tryParse(_selectedBedrooms);
            return locationMatch && priceMatch && bedroomMatch;
          }).toList();
      _showFilters = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedLocation = "All";
      _selectedPriceRange = "Any";
      _selectedBedrooms = "Any";
      _filteredProperties = _allProperties;
      _showFilters = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            // autofocus: true,
            // keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.green),
              hintText: 'Search for properties...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.green),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFiltersPanel(),
          _buildFilterChips(),
          Expanded(
            child:
                _filteredProperties.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No properties found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          if (_searchController.text.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                _performSearch();
                              },
                              child: Text('Clear search'),
                            ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredProperties.length,
                      itemBuilder: (context, index) {
                        return PropertyCard(
                          property: _filteredProperties[index],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          _buildFilterDropdown(
            label: 'Location',
            value: _selectedLocation,
            items: [
              'All',
              'Uttara',
              'Dhanmondi',
              'Mirpur',
              'Gulshan',
              'Banani',
            ],
            onChanged: (value) {
              setState(() {
                _selectedLocation = value!;
              });
            },
          ),
          SizedBox(height: 16),
          _buildFilterDropdown(
            label: 'Price Range',
            value: _selectedPriceRange,
            items: [
              'Any',
              'Under 5000',
              '5000-10000',
              '10000-20000',
              'Above 20000',
            ],
            onChanged: (value) {
              setState(() {
                _selectedPriceRange = value!;
              });
            },
          ),
          SizedBox(height: 16),
          _buildFilterDropdown(
            label: 'Bedrooms',
            value: _selectedBedrooms,
            items: ['Any', '1', '2', '3', '4+'],
            onChanged: (value) {
              setState(() {
                _selectedBedrooms = value!;
              });
            },
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.green),
                  ),
                  child: Text('Reset', style: TextStyle(color: Colors.green)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Apply', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items:
              items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final activeFilters = [
      if (_selectedLocation != "All") _selectedLocation,
      if (_selectedPriceRange != "Any") _selectedPriceRange,
      if (_selectedBedrooms != "Any") '${_selectedBedrooms} Beds',
    ];

    if (activeFilters.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            activeFilters.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(filter),
                  backgroundColor: Colors.green[100],
                  deleteIcon: Icon(Icons.close, size: 16),
                  onDeleted: () {
                    if (filter == _selectedLocation) {
                      setState(() {
                        _selectedLocation = "All";
                      });
                    } else if (filter == _selectedPriceRange) {
                      setState(() {
                        _selectedPriceRange = "Any";
                      });
                    } else if (filter.contains('Beds')) {
                      setState(() {
                        _selectedBedrooms = "Any";
                      });
                    }
                    _applyFilters();
                  },
                ),
              );
            }).toList(),
      ),
    );
  }
}
