import 'package:flutter/material.dart';

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