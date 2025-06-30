import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/filter_params.dart';
import '../cubit/search_cubit.dart';
import 'package:go_router/go_router.dart';

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
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchLoading) {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Applying filters...'),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (state is FilterLoaded) {
          // Filter applied successfully, navigate back to search
          context.pop();
        } else if (state is SearchError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: FractionallySizedBox(
        heightFactor: 0.90,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: const Icon(
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
                style: const TextStyle(
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
                  const SizedBox(height: 4),
                  TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
            const SizedBox(width: 16),
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
                  const SizedBox(height: 4),
                  TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Colors.white,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16),
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
            const SizedBox(width: 8),
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final isLoading = state is SearchLoading;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Clear All button (left)
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
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
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Done button (right)
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Apply filters and close modal
                          _applyFilters();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    // Get selected amenities
    final selectedAmenities = amenities.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Check if any filters are selected
    final hasFilters = selectedRoomType != null ||
        numberOfSeats > 0 ||
        minPriceController.text.isNotEmpty ||
        maxPriceController.text.isNotEmpty ||
        selectedAmenities.isNotEmpty ||
        selectedPlan != null ||
        selectedPaymentMethod != null;

    if (!hasFilters) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one filter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create filter parameters
    final filterParams = FilterParams(
      roomType: selectedRoomType,
      numberOfSeats: numberOfSeats > 0 ? numberOfSeats : null,
      minPrice: minPriceController.text.isNotEmpty
          ? double.tryParse(minPriceController.text)
          : null,
      maxPrice: maxPriceController.text.isNotEmpty
          ? double.tryParse(maxPriceController.text)
          : null,
      amenities: selectedAmenities.isNotEmpty ? selectedAmenities : null,
      plan: selectedPlan,
      paymentMethod: selectedPaymentMethod,
    );

    // Apply filters using the cubit
    context.read<SearchCubit>().filterRooms(filterParams);
  }
}
