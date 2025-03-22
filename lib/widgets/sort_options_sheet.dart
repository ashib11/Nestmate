import 'package:flutter/material.dart';

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