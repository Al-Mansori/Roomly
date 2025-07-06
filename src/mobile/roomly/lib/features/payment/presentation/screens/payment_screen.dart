import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../GlobalWidgets/app_session.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/card_entity.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/customized_card_widget.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String paymentFor;
  final String userId;
  final String reservationId;
  final String paymentMethod;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.paymentFor,
    required this.userId,
    required this.reservationId,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _enteredCVV = '';

  @override
  void initState() {
    super.initState();
    _loadUserCards();
  }

  Future<void> _loadUserCards() async {
    UserEntity? user = AppSession().currentUser;
    final String? userId = user?.id;
    if (userId != null) {
      context.read<PaymentCubit>().getUserCards(userId);
    }
  }

  void _processPayment(String cardId, String cardNumber, String cvv) {
    if (widget.userId != null && cvv.isNotEmpty && cvv.length >= 3) {
      context.read<PaymentCubit>().processPayment(
        cardId: cardId,
        cardNumber: cardNumber,
        cvv: cvv,
        amount: widget.amount,
        reservationId: widget.reservationId,
        userId: widget.userId,
        paymentMethod: widget.paymentMethod.toUpperCase(),
      );
    }
  }

  void _showPaymentDialog(String cardId, String cardNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Authorization'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${widget.paymentFor} Booking'),
            const SizedBox(height: 8),
            Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Important: No funds will be charged at this time. '
                  'This is a temporary authorization to ensure your payment method is valid. '
                  'Actual charges will only occur after your booking period starts.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text('Enter CVV:'),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '3-digit security code',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 3,
              onChanged: (value) => _enteredCVV = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_enteredCVV.length < 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid 3-digit CVV')));
                return;
              }
              Navigator.pop(context);
              _processPayment(cardId, cardNumber, _enteredCVV);
            },
            child: const Text('Authorize Payment'),
          ),
        ],
      ),
    );
  }

  void _showPaymentResultDialog(String message, Map<String, dynamic> apiResponse) {
    final isSuccess = apiResponse['Status'] == 'CONFIRMED';
    final isInsufficientBalance = message.contains('insufficient') ||
        message.contains('balance');
    final isInvalidCVV = message.contains('CVV') ||
        message.contains('security code');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          isSuccess ? 'Payment Authorized!' :
          isInsufficientBalance ? 'Insufficient Funds' :
          isInvalidCVV ? 'Invalid Security Code' :
          'Payment Issue',
          style: TextStyle(
            color: isSuccess ? Colors.green : Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSuccess) ...[
              Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              const Text('Your payment method has been successfully authorized.'),
              const SizedBox(height: 8),
              const Text('No funds have been charged yet.'),
              const SizedBox(height: 16),
              const Text('You earned 5 loyalty points!'),
            ],
            if (isInsufficientBalance) ...[
              const Text('Your payment could not be authorized because:'),
              const SizedBox(height: 8),
              const Text('• Your account has insufficient funds'),
              const SizedBox(height: 8),
              const Text('Please try another payment method or add funds to your account.'),
            ],
            if (isInvalidCVV) ...[
              const Text('Your payment could not be authorized because:'),
              const SizedBox(height: 8),
              const Text('• The security code (CVV) you entered is incorrect'),
              const SizedBox(height: 8),
              const Text('Please check your card and try again.'),
            ],
            if (!isSuccess && !isInsufficientBalance && !isInvalidCVV) ...[
              Text(message),
              const SizedBox(height: 8),
              const Text('Please try again or contact support.'),
            ],
          ],
        ),
        actions: [
          if (!isSuccess)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Try Again'),
            ),
          if (isSuccess)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(
                  '/reservation-qrcode',
                  extra: apiResponse,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('View Reservation'),
            ),
        ],
      ),
    );
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
          'Payment Authorization',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentCardAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card added successfully!')));
          } else if (state is PaymentProcessed) {
            _showPaymentResultDialog(
              'Payment authorization successful!',
              state.apiResponse,
            );
          } else if (state is PaymentError) {
            _showPaymentResultDialog(state.message, {});
          }
        },
        builder: (context, state) {
          if (state is PaymentProcessing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing your payment authorization...'),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Service: ${widget.paymentFor} Booking',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Amount: \$${widget.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                const SingleChildScrollView(
                  child: Text(
                    'Note: This is a temporary authorization. Your card will not be charged until your booking period begins.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Payment Method:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Saved Cards:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildCardsList(context, state),
                ),
                _buildAddCardButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardsList(BuildContext context, PaymentState state) {
    if (state is PaymentLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is PaymentError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load cards',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserCards,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is PaymentCardsLoaded) {
      if (state.cards.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card,
                size: 64,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'No Saved Payment Methods',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add a card to complete your booking',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: state.cards.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final card = state.cards[index];
          return CustomizedCardWidget(
            card: card,
            onPayPressed: () => _showPaymentDialog(
              card.id,
              card.cardNumber,
            ),
          );
        },
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildAddCardButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: ElevatedButton(
        onPressed: () async {
          final result = await context.push<bool>('/add-card');
          if (result == true) {
            _loadUserCards();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Add New Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

extension CardEntityExtension on CardEntity {
  String get id => userId;
  String get type => 'visa';
  String get last4 => cardNumber.length >= 4
      ? cardNumber.substring(cardNumber.length - 4)
      : cardNumber;
}