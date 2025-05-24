import 'package:flutter/material.dart';

class FilterPopupScreen extends StatefulWidget {
  const FilterPopupScreen({Key? key}) : super(key: key);

  @override
  _FilterPopupScreenState createState() => _FilterPopupScreenState();
}

class _FilterPopupScreenState extends State<FilterPopupScreen> {
  // Room type selection
  String? selectedRoomType;
  
  // Number of seats
  int numberOfSeats = 0;
  
  // Price range
  double priceValue = 500.0;
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  
  // Amenities selection
  final Map<String, bool> amenities = {
    'WiFi': false,
    'Free Coffee': false,
    'Free Parking': false,
    'Printer': false,
  };
  
  // Plan selection
  String? selectedPlan;
  
  // Payment method selection
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoomTypeSection(),
                    _buildDivider(),
                    _buildNumberOfSeatsSection(),
                    _buildDivider(),
                    _buildPriceRangeSection(),
                    _buildDivider(),
                    _buildAmenitiesSection(),
                    _buildDivider(),
                    _buildYourPlanSection(),
                    _buildDivider(),
                    _buildPaymentMethodSection(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 24,
      thickness: 0.5,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildRoomTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Room Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildRadioListTile(
          title: 'Desk',
          value: 'desk',
          groupValue: selectedRoomType,
          icon: Icons.music_note,
          onChanged: (value) {
            setState(() {
              selectedRoomType = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Meeting Room',
          value: 'meeting_room',
          groupValue: selectedRoomType,
          icon: Icons.people,
          onChanged: (value) {
            setState(() {
              selectedRoomType = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Gaming Room',
          value: 'gaming_room',
          groupValue: selectedRoomType,
          icon: Icons.sports_esports,
          onChanged: (value) {
            setState(() {
              selectedRoomType = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Seminar',
          value: 'seminar',
          groupValue: selectedRoomType,
          icon: Icons.desktop_windows,
          onChanged: (value) {
            setState(() {
              selectedRoomType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRadioListTile({
    required String title,
    required String value,
    required String? groupValue,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.black87,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberOfSeatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.person,
                size: 20,
                color: Colors.black87,
              ),
              SizedBox(width: 12),
              Text(
                'Number of seats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepperButton(
              icon: Icons.remove,
              onPressed: numberOfSeats > 0
                  ? () {
                      setState(() {
                        numberOfSeats--;
                      });
                    }
                  : null,
            ),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '$numberOfSeats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildStepperButton(
              icon: Icons.add,
              onPressed: () {
                setState(() {
                  numberOfSeats++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: onPressed == null ? Colors.grey.shade100 : Colors.white,
        ),
        child: Icon(
          icon,
          size: 20,
          color: onPressed == null ? Colors.grey.shade400 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Price range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Min',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Max',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Colors.white,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: priceValue,
                  min: 0,
                  max: 1000,
                  onChanged: (value) {
                    setState(() {
                      priceValue = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              '\$${priceValue.toInt()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Amenities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildCheckboxListTile(
          title: 'WiFi',
          value: amenities['WiFi']!,
          icon: Icons.wifi,
          onChanged: (value) {
            setState(() {
              amenities['WiFi'] = value!;
            });
          },
        ),
        _buildCheckboxListTile(
          title: 'Free Coffee',
          value: amenities['Free Coffee']!,
          icon: Icons.coffee,
          onChanged: (value) {
            setState(() {
              amenities['Free Coffee'] = value!;
            });
          },
        ),
        _buildCheckboxListTile(
          title: 'Free Parking',
          value: amenities['Free Parking']!,
          icon: Icons.local_parking,
          onChanged: (value) {
            setState(() {
              amenities['Free Parking'] = value!;
            });
          },
        ),
        _buildCheckboxListTile(
          title: 'Printer',
          value: amenities['Printer']!,
          icon: Icons.print,
          onChanged: (value) {
            setState(() {
              amenities['Printer'] = value!;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () {
              // Handle show all amenities
            },
            child: Text(
              'Show all',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxListTile({
    required String title,
    required bool value,
    required IconData icon,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.black87,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYourPlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Your plan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildRadioListTile(
          title: 'Hourly',
          value: 'hourly',
          groupValue: selectedPlan,
          icon: Icons.access_time,
          onChanged: (value) {
            setState(() {
              selectedPlan = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Daily',
          value: 'daily',
          groupValue: selectedPlan,
          icon: Icons.calendar_today,
          onChanged: (value) {
            setState(() {
              selectedPlan = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Monthly',
          value: 'monthly',
          groupValue: selectedPlan,
          icon: Icons.calendar_month,
          onChanged: (value) {
            setState(() {
              selectedPlan = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Annual',
          value: 'annual',
          groupValue: selectedPlan,
          icon: Icons.calendar_view_month,
          onChanged: (value) {
            setState(() {
              selectedPlan = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Payment method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildRadioListTile(
          title: 'Credit',
          value: 'credit',
          groupValue: selectedPaymentMethod,
          icon: Icons.credit_card,
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value;
            });
          },
        ),
        _buildRadioListTile(
          title: 'Cash',
          value: 'cash',
          groupValue: selectedPaymentMethod,
          icon: Icons.money,
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle clear all results
            setState(() {
              selectedRoomType = null;
              numberOfSeats = 0;
              priceValue = 500.0;
              minPriceController.clear();
              maxPriceController.clear();
              amenities.forEach((key, value) {
                amenities[key] = false;
              });
              selectedPlan = null;
              selectedPaymentMethod = null;
            });
            // Optionally close the popup after clearing
            // Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Clear All Results',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
