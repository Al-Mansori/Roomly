import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/home/presentation/bloc/cubit/workspace_cubit.dart';
import 'package:roomly/features/home/presentation/widget/nearby_workspace.dart';
import 'package:roomly/features/home/presentation/widget/recommended_rooms.dart';
import 'package:roomly/features/home/presentation/component/categories_section.dart';
import 'package:roomly/features/home/presentation/component/search_section.dart';

import '../../../GlobalWidgets/app_session.dart';
import '../../../GlobalWidgets/navBar.dart';
import '../../../auth/data/data_sources/secure_storage.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../component/skeleton_loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;
  bool _isScrollingDown = false;
  int _selectedIndex = 0;
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserId();
    _scrollController.addListener(_onScroll);
  }
  Future<void> loadUserId() async {
    UserEntity? user = AppSession().currentUser;
    setState(() {
      userId = user?.id;
      isLoading = false;
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward ||
        _scrollController.position.atEdge) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() => _selectedIndex = 0);
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
                builder: (context, state) {
                  if (state is WorkspaceInitial || state is WorkspaceLoading) {
                    return const HomeSkeletonLoading();
                  }
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchSection(),
                        SizedBox(height: 20),
                        RecommendedRooms(),
                        SizedBox(height: 20),
                        NearbyWorkspaces(),
                        SizedBox(height: 20),
                        CategoriesSection(),
                        SizedBox(height: 120),
                      ],
                    ),
                  );
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? -100
                  : (_isNavVisible ? 20 : -80),
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isNavVisible && MediaQuery.of(context).viewInsets.bottom == 0
                    ? 1.0
                    : 0.0,
                child: BottomNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

