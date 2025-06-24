import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/customized_card_widget.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserCards();
  }

  Future<void> _loadUserCards() async {
    final userId = await SecureStorage.getId();
    if (userId != null) {
      context.read<PaymentCubit>().getUserCards(userId);
    }
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment'),
        content: const Text('Payment functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadUserCards(); // Reload cards after successful addition
            },
            child: const Text('OK'),
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
      body: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentCardAdded) {
            _showSuccessDialog('Card added successfully!');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Cards List
              Expanded(
                child: BlocBuilder<PaymentCubit, PaymentState>(
                  builder: (context, state) {
                    if (state is PaymentLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is PaymentError) {
                      // Show a nice empty state when there are no cards
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.credit_card_off,
                              size: 64,
                              color: Colors.green, // Changed to green
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Available Cards',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green, // Green color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add your first card to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadUserCards,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Green button
                                foregroundColor: Colors.white,
                              ),
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
                                Icons.credit_card_off,
                                size: 64,
                                color: Colors.green, // Changed to green
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Available Cards',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green, // Green color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Add your first card to get started',
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
                        separatorBuilder: (context, index) => const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final card = state.cards[index];
                          return CustomizedCardWidget(
                            card: card,
                            onPayPressed: _showPaymentDialog,
                          );
                        },
                      );
                    }
                    
                    return const Center(
                      child: Text('Welcome! Tap the button below to add your first card.'),
                    );
                  },
                ),
              ),


              // Add Card Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to Add Card Screen using GoRouter
                    final result = await context.push<bool>('/add-card',);
                    
                    // If card was added successfully, reload the cards
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
      ),
    );
  }
}

