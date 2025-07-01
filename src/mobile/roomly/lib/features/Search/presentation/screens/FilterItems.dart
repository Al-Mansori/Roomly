import 'package:flutter/material.dart';

class FiltersSection extends StatefulWidget {
  const FiltersSection({super.key});

  @override
  _FiltersSectionState createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  // Track the selected state of each filter
  Map<String, bool> filters = {
    "Space type": false,
    "Plane": false,
    "Price Range": false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "Filters",
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.keys.map((label) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    label,
                    style: TextStyle(
                      color: filters[label]! ? Colors.blue : Colors.black,
                    ),
                  ),
                  selected: filters[label]!,
                  onSelected: (bool selected) {
                    setState(() {
                      filters[label] = selected;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.blue.withOpacity(0.2),
                  checkmarkColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
