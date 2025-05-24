// features/account/presentation/cards_screen.dart
import 'package:flutter/material.dart';
import 'package:roomly/features/payment/presentation/add_card_screen.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final TextEditingController _cvv1Controller =
      TextEditingController(text: '2**');
  final TextEditingController _cvv2Controller =
      TextEditingController(text: '5**');

  @override
  void dispose() {
    _cvv1Controller.dispose();
    _cvv2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cards',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // First Credit Card
            _buildCreditCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF006064), Color(0xFF4DD0E1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              cardNumber: '5242 - 4343 - 8348 - 4878',
              cardHolder: 'DJ Snake',
            ),

            // CVV Field for first card
            _buildCvvField(_cvv1Controller),

            const SizedBox(height: 20),

            // Second Credit Card
            _buildCreditCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF006064), Color(0xFF4DD0E1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              cardNumber: '3456 - 4356 - 3294 - 4435',
              cardHolder: 'DJ Snake',
            ),

            // CVV Field for second card
            _buildCvvField(_cvv2Controller),

            const Spacer(),

            // Add Card Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Card',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard({
    required LinearGradient gradient,
    required String cardNumber,
    required String cardHolder,
  }) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Credit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 45,
                height: 30,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            cardHolder,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCvvField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          const Text(
            'CVV ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 3,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
