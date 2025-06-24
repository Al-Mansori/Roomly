import 'package:flutter/material.dart';
import '../../domain/entities/card_entity.dart';

class CustomizedCardWidget extends StatefulWidget {
  final CardEntity? card;
  final VoidCallback? onPayPressed;
  // New parameters for real-time card display
  final String? displayCardName;
  final String? displayCardNumber;
  final String? displayExpiry;
  final bool isPreview;

  const CustomizedCardWidget({
    Key? key,
    this.card,
    this.onPayPressed,
    this.displayCardName,
    this.displayCardNumber,
    this.displayExpiry,
    this.isPreview = false,
  }) : super(key: key);

  @override
  State<CustomizedCardWidget> createState() => _CustomizedCardWidgetState();
}

class _CustomizedCardWidgetState extends State<CustomizedCardWidget> {
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cvvController.dispose();
    super.dispose();
  }

  String get cardHolderName {
    if (widget.isPreview && widget.displayCardName != null) {
      return widget.displayCardName!;
    }
    return 'Credit Card';
  }

  String get cardNumber {
    if (widget.isPreview && widget.displayCardNumber != null) {
      return widget.displayCardNumber!;
    }
    return widget.card?.formattedCardNumber ?? '**** **** **** ****';
  }

  String get expiryDate {
    if (widget.isPreview && widget.displayExpiry != null) {
      return widget.displayExpiry!;
    }
    return 'MM/YYYY';
  }

  String _getCardType() {
    String number = cardNumber.replaceAll(' ', '').replaceAll('*', '');
    if (number.isEmpty) return 'MC';
    
    // Visa cards start with 4
    if (number.startsWith('4')) {
      return 'VISA';
    }
    // Mastercard cards start with 5 or 2
    else if (number.startsWith('5') || number.startsWith('2')) {
      return 'MC';
    }
    // American Express cards start with 3
    else if (number.startsWith('3')) {
      return 'AMEX';
    }
    // Default to Mastercard
    else {
      return 'MC';
    }
  }

  Color _getCardColor() {
    String cardType = _getCardType();
    switch (cardType) {
      case 'VISA':
        return const Color(0xFF1A1F71);
      case 'AMEX':
        return const Color(0xFF006FCF);
      default: // Mastercard
        return const Color(0xFF00695C);
    }
  }

  Color _getCardGradientColor() {
    String cardType = _getCardType();
    switch (cardType) {
      case 'VISA':
        return const Color(0xFF4A90E2);
      case 'AMEX':
        return const Color(0xFF0099CC);
      default: // Mastercard
        return const Color(0xFF4DB6AC);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Credit Card Design
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getCardColor(),
                _getCardGradientColor(),
              ],
            ),
          ),
          child: Padding(
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
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Card type logo
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          _getCardType(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Card holder name
                Text(
                  cardHolderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                // Card number
                Text(
                  cardNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                // Expiry date
                Text(
                  expiryDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Only show CVV input and Pay button if not in preview mode
        if (!widget.isPreview) ...[
          const SizedBox(height: 16),
          // CVV Input and Pay Button
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'CVV ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF1976D2)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_cvvController.text.isNotEmpty && widget.onPayPressed != null) {
                        widget.onPayPressed!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Pay !',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

