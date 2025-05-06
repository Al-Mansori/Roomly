// profile_form.dart
import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  final String email;
  final Function(Map<String, dynamic>) onSavePressed;

  const ProfileForm({
    super.key,
    required this.email,
    required this.onSavePressed,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          minWidth: 300,
        ),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Avatar and Email
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0A3FB3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  // Name Row
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                hint: 'First',
                                controller: _firstNameController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildInputField(
                                hint: 'Last',
                                controller: _lastNameController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email (read-only)
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.email,
                          decoration: InputDecoration(
                            hintText: widget.email,
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8E8991),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFDBD9DC)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Location
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildInputField(
                          hint: '30street-dokki',
                          controller: _locationController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Phone',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildInputField(
                          hint: 'xxx-xxx-xxx',
                          controller: _phoneController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  final profileData = {
                    'firstName': _firstNameController.text,
                    'lastName': _lastNameController.text,
                    'address': _locationController.text,
                    'phone': _phoneController.text,
                  };
                  widget.onSavePressed(profileData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3FB3),
                  minimumSize: const Size(78, 27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return SizedBox(
      height: 30,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8E8991),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDBD9DC)),
          ),
        ),
      ),
    );
  }
}