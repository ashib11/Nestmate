import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = "All";
  String _selectedPriceRange = "Any";
  String _selectedBedrooms = "Any";
  bool _showFilters = false;

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
      _filteredProperties = _allProperties.where((property) {
        final locationMatch = property.location.toLowerCase().contains(query);
        final priceMatch = property.price.toLowerCase().contains(query);
        final bedroomMatch = property.bedroom.toString().contains(query);
        return locationMatch || priceMatch || bedroomMatch;
      }).toList();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredProperties = _allProperties.where((property) {
        bool locationMatch = _selectedLocation == "All" || property.location.contains(_selectedLocation);

        bool priceMatch = true;
        final price = int.tryParse(property.price.split(' ')[0]) ?? 0;
        switch (_selectedPriceRange) {
          case "Under 5000":
            priceMatch = price < 5000;
            break;
          case "5000-10000":
            priceMatch = price >= 5000 && price <= 10000;
            break;
          case "10000-20000":
            priceMatch = price >= 10000 && price <= 20000;
            break;
          case "Above 20000":
            priceMatch = price > 20000;
            break;
        }

        bool bedroomMatch = _selectedBedrooms == "Any" ||
            (_selectedBedrooms == "4+" ? property.bedroom >= 4 : property.bedroom == int.tryParse(_selectedBedrooms));

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

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search properties...",
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.green),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
      icon: Icon(_showFilters ? Icons.close : Icons.filter_list, color: Colors.green),
      onPressed: () => setState(() => _showFilters = !_showFilters),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 70, color: Colors.grey),
          SizedBox(height: 16),
          Text("No results found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          if (_searchController.text.isNotEmpty)
            TextButton(
              onPressed: () {
                _searchController.clear();
                _performSearch();
              },
              child: Text("Clear Search", style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    return ListView.builder(
      itemCount: _filteredProperties.length,
      itemBuilder: (context, index) => PropertyCard(property: _filteredProperties[index]),
    );
  }

  Widget _buildFiltersPanel() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFilterDropdown(
            label: 'Location',
            value: _selectedLocation,
            items: ['All', 'Uttara', 'Dhanmondi', 'Mirpur', 'Gulshan', 'Banani'],
            onChanged: (value) => setState(() => _selectedLocation = value!),
          ),
          SizedBox(height: 16),
          _buildFilterDropdown(
            label: 'Price Range',
            value: _selectedPriceRange,
            items: ['Any', 'Under 5000', '5000-10000', '10000-20000', 'Above 20000'],
            onChanged: (value) => setState(() => _selectedPriceRange = value!),
          ),
          SizedBox(height: 16),
          _buildFilterDropdown(
            label: 'Bedrooms',
            value: _selectedBedrooms,
            items: ['Any', '1', '2', '3', '4+'],
            onChanged: (value) => setState(() => _selectedBedrooms = value!),
          ),
          SizedBox(height: 24),
          _buildFilterButtons(),
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
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Reset", style: TextStyle(color: Colors.green)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final activeFilters = [
      if (_selectedLocation != "All") _selectedLocation,
      if (_selectedPriceRange != "Any") _selectedPriceRange,
      if (_selectedBedrooms != "Any") "${_selectedBedrooms} Beds",
    ];

    if (activeFilters.isEmpty) return SizedBox();

    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: activeFilters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(filter),
              backgroundColor: Colors.green.shade100,
              deleteIcon: Icon(Icons.close),
              onDeleted: () {
                if (filter == _selectedLocation) _selectedLocation = "All";
                else if (filter == _selectedPriceRange) _selectedPriceRange = "Any";
                else if (filter.contains('Beds')) _selectedBedrooms = "Any";
                _applyFilters();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: _buildSearchBar(),
        actions: [_buildFilterButton()],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFiltersPanel(),
          _buildFilterChips(),
          Expanded(
            child: _filteredProperties.isEmpty ? _buildEmptyState() : _buildPropertyList(),
          ),
        ],
      ),
    );
  }
}
