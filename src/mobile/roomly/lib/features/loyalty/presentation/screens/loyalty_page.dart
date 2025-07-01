import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:roomly/core/network/network_info.dart';
import 'package:roomly/features/loyalty/data/data_source/loyalty_points_remote_data_source.dart';
import 'package:roomly/features/loyalty/data/repository/loyalty_points_repository_impl.dart';
import 'package:roomly/features/loyalty/domain/entities/loyalty_points_entity.dart';
import 'package:roomly/features/loyalty/domain/usecases/loyalty_points_usecases.dart';
import 'package:roomly/features/loyalty/presentation/cubit/loyalty_points_cubit.dart';
import 'package:roomly/features/loyalty/presentation/cubit/loyalty_points_state.dart';
import 'package:roomly/features/loyalty/presentation/widgets/expiration_warning.dart';
import 'package:roomly/features/loyalty/presentation/widgets/loyalty_header_section.dart';
import 'package:roomly/features/loyalty/presentation/widgets/points_vouchers_section.dart';
import 'package:roomly/features/loyalty/presentation/widgets/workspace_card.dart';

import '../../../GlobalWidgets/app_session.dart';
import '../../../auth/domain/entities/user_entity.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createLoyaltyPointsCubit(),
      child: const LoyaltyPageContent(),
    );
  }

  // Helper method to create LoyaltyPointsCubit with all dependencies
  LoyaltyPointsCubit _createLoyaltyPointsCubit() {
    // Create HTTP client
    final httpClient = http.Client();
    
    // Create network info
    final networkInfo = NetworkInfoImpl(InternetConnectionChecker.createInstance());
    
    // Create remote data source
    final remoteDataSource = LoyaltyPointsRemoteDataSourceImpl(client: httpClient);
    
    // Create repository
    final repository = LoyaltyPointsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    
    // Create use cases
    final getLoyaltyPointsUseCase = GetLoyaltyPoints(repository);
    final addLoyaltyPointsUseCase = AddLoyaltyPoints(repository);
    final redeemLoyaltyPointsUseCase = RedeemLoyaltyPoints(repository);
    
    // Create and return cubit
    return LoyaltyPointsCubit(
      getLoyaltyPointsUseCase: getLoyaltyPointsUseCase,
      addLoyaltyPointsUseCase: addLoyaltyPointsUseCase,
      redeemLoyaltyPointsUseCase: redeemLoyaltyPointsUseCase,
    );
  }
}

class LoyaltyPageContent extends StatefulWidget {
  const LoyaltyPageContent({super.key});

  @override
  State<LoyaltyPageContent> createState() => _LoyaltyPageContentState();
}

class _LoyaltyPageContentState extends State<LoyaltyPageContent> {
  String _userName = 'User';
  String _userId = 'Id';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    // Use WidgetsBinding to ensure the widget tree is built before accessing the cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoyaltyPointsCubit>().loadLoyaltyPoints();
      }
    });
  }

  Future<void> _loadUserName() async {
    try {
      final UserEntity? userData = AppSession().currentUser;

      if (userData != null && mounted) {
        final firstName = userData.firstName ?? '';
        final lastName = userData.lastName ?? '';
        
        setState(() {
          if (firstName.isNotEmpty && lastName.isNotEmpty) {
            _userName = '$firstName $lastName';
            _userId = userData.id ?? '';
          } else if (firstName.isNotEmpty) {
            _userName = firstName;
            _userId = userData.id ?? '';
          } else if (lastName.isNotEmpty) {
            _userName = lastName;
            _userId = userData.id ?? '';
          } else {
            _userName = userData.email;
            _userId = userData.id ?? '';
          }
        });
      }
    } catch (e) {
      // Handle error silently, keep default name
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section with Blue Background
          LoyaltyHeaderSection(
            userName: _userName,
            onRefresh: () => context.read<LoyaltyPointsCubit>().refreshLoyaltyPoints(),
            onBack: () => Navigator.pop(context),
          ),
          // Content Section
          Expanded(
            child: BlocConsumer<LoyaltyPointsCubit, LoyaltyPointsState>(
              listener: (context, state) {
                if (state is LoyaltyPointsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<LoyaltyPointsCubit>().loadLoyaltyPoints();
                        },
                      ),
                    ),
                  );
                } else if (state is LoyaltyPointsActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<LoyaltyPointsCubit>().refreshLoyaltyPoints();
                  },
                  child: _buildContentSection(state),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(LoyaltyPointsState state) {
    if (state is LoyaltyPointsLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is LoyaltyPointsError) {
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
            Text(
              'Error loading loyalty points',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<LoyaltyPointsCubit>().loadLoyaltyPoints();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    LoyaltyPointsEntity? loyaltyPoints;
    bool isActionLoading = false;
    String actionType = '';

    if (state is LoyaltyPointsLoaded) {
      loyaltyPoints = state.loyaltyPoints;
    } else if (state is LoyaltyPointsActionLoading) {
      loyaltyPoints = state.currentLoyaltyPoints;
      isActionLoading = true;
      actionType = state.action;
    } else if (state is LoyaltyPointsActionSuccess) {
      loyaltyPoints = state.loyaltyPoints;
    }

    // Handle null loyaltyPoints by creating a default entity with 0 points
    final effectiveLoyaltyPoints = loyaltyPoints ?? LoyaltyPointsEntity(
      totalPoints: 0,
      lastAddedPoint: 0,
      lastUpdatedDate: DateTime.now(), 
      userId: _userId,
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Points and Vouchers Section
            PointsVouchersSection(
              loyaltyPoints: effectiveLoyaltyPoints,
              isActionLoading: isActionLoading,
              actionType: actionType,
            ),
            const SizedBox(height: 20),
            // Expiration Warning
            ExpirationWarning(loyaltyPoints: effectiveLoyaltyPoints),
            const SizedBox(height: 20),
            // Workspace Cards
            Column(
              children: [
                WorkspaceCard(
                  title: 'Private Room',
                  subtitle: 'in workspace-name',
                  details: '1-5 seats • 2.4 KM away',
                  imagePath: 'assets/images/private_room.jpg',
                  pointsCost: 500,
                  loyaltyPoints: effectiveLoyaltyPoints,
                  isActionLoading: isActionLoading,
                  onRedeem: _showRedeemDialog,
                ),
                const SizedBox(height: 16),
                WorkspaceCard(
                  title: 'Desk',
                  subtitle: 'in workspace-name',
                  details: '',
                  imagePath: 'assets/images/desk.jpg',
                  pointsCost: 200,
                  loyaltyPoints: effectiveLoyaltyPoints,
                  isActionLoading: isActionLoading,
                  onRedeem: _showRedeemDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRedeemDialog(int pointsCost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redeem Points'),
          content: Text('Are you sure you want to redeem $pointsCost points for this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<LoyaltyPointsCubit>().redeemPoints(pointsCost);
              },
              child: const Text('Redeem'),
            ),
          ],
        );
      },
    );
  }
}

