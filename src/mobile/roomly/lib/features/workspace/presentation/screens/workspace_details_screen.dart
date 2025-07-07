import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/GlobalWidgets/ReusableCarrasoul.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/presentation/cubits/workspace_details_cubit.dart';
import 'package:roomly/features/workspace/presentation/screens/location_map_widget.dart';
import 'package:roomly/features/workspace/presentation/screens/workspace_listings_screen.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';
import 'package:roomly/features/workspace/presentation/screens/workspace_schedule_popup.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkspaceDetailsScreen extends StatefulWidget {
  final String workspaceId;

  const WorkspaceDetailsScreen({Key? key, required this.workspaceId}) : super(key: key);

  @override
  State<WorkspaceDetailsScreen> createState() => _WorkspaceDetailsScreenState();
}

class _WorkspaceDetailsScreenState extends State<WorkspaceDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // For bottom navigation bar
  // PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // This empty setState is crucial to rebuild the widget tree
          // and reflect the tab change in TabBarView.
        });
      }
    });
    context.read<WorkspaceDetailsCubit>().getWorkspaceDetails(widget.workspaceId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _pageController.dispose();
    super.dispose();
  }

  Widget _buildImageSection(List<dynamic> images) {
    // Extract image URLs from the images list
    final imageUrls = images
        .map((image) => image.imageUrl)
        .whereType<String>()
        .toList();

    return Stack(
      children: [
        ReusableCarousel(
          images: imageUrls.isNotEmpty
              ? imageUrls
              : ['https://media.istockphoto.com/id/1337718884/photo/modern-office-at-home.jpg?s=612x612&w=0&k=20&c=kXlpCzVsqV360jaC9UkaXGhcGh8VLURkybD9NqBfQKE='],
          height: 200,
          autoPlay: true,
        ),
        // Back button
        Positioned(
          top: 20,
          left: 10,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultLogo() {
    return Stack(
      children: [
        Container(
          height: 200,
          color: Colors.grey.shade200,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/roomly_small.svg',
              width: 120,
              height: 120,
            ),
          ),
        ),
        // Back button
        Positioned(
          top: 20,
          left: 10,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(int reviewCount) {
    return GestureDetector(
      onTap: () {
        // Navigate to reviews screen with workspaceId
        context.push('/reviews/${widget.workspaceId}');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews($reviewCount)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenHoursSection(WorkspaceDetailsLoaded state) {
    // Get current day schedule
    String getCurrentDaySchedule() {
      if (state.schedules == null || state.schedules!.isEmpty) {
        return 'Today: 10:00 am - 11:59 pm'; // Default fallback
      }
      
      final now = DateTime.now();
      final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final currentDay = days[now.weekday - 1];
      
      final todaySchedule = state.schedules!.firstWhere(
        (schedule) => schedule.day == currentDay,
        orElse: () => state.schedules!.first,
      );
      
      return 'Today: ${todaySchedule.startTime} - ${todaySchedule.endTime}';
    }

    return GestureDetector(
      onTap: () {
        if (state.schedules != null && state.schedules!.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return WorkspaceSchedulePopup(schedules: state.schedules!);
            },
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Open Hours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                getCurrentDaySchedule(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (state.schedules != null && state.schedules!.isNotEmpty) ...[
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image carousel or logo section
            BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
              builder: (context, state) {
                if (state is WorkspaceDetailsLoaded) {
                  final workspace = state.workspace;
                  if (workspace is WorkspaceModel && 
                      workspace.workspaceImages != null && 
                      workspace.workspaceImages!.isNotEmpty) {
                    return _buildImageSection(workspace.workspaceImages!);
                  }
                }
                return _buildDefaultLogo();
              },
            ),

            const SizedBox(height: 16),

            // Tab bar

            Container(
  margin: const EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(35),
  ),
  child: TabBar(
    controller: _tabController,
    indicator: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    // This makes the indicator wider by reducing space between tab label and indicator edges
    indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    // This makes the indicator take more width relative to the tab
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    tabs: const [
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8), // Add padding to tab text
          child: Text('WorkSpace Listings'),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8), // Add padding to tab text
          child: Text('WorkSpace Details'),
        ),
      ),
    ],
  ),
),

            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade200,
            //     borderRadius: BorderRadius.circular(35),
            //   ),
            //   child: TabBar(
            //     controller: _tabController,
            //     indicator: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(35),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.2),
            //           spreadRadius: 1,
            //           blurRadius: 4,
            //           offset: const Offset(0, 2),
                      
            //         ),
            //       ],
            //     ),
            //     labelColor: Colors.black,
            //     unselectedLabelColor: Colors.grey,
            //     tabs: const [
            //       Tab(text: 'WorkSpace Listings'),
            //       Tab(text: 'WorkSpace Details'),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
                builder: (context, state) {
                  if (state is WorkspaceDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WorkspaceDetailsLoaded) {
                    final WorkspaceEntity workspace = state.workspace;
                    final int reviewCount = state.reviewCount ?? 0;
                    
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // Workspace Listings Tab
                        const WorkspaceListingsScreen(),

                        // Workspace Details Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workspace.name,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${workspace.type ?? 'N/A'}', // Placeholder for distance
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${workspace.avgRating?.toStringAsFixed(1) ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'About Workspace',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                workspace.description ?? 'No description available.',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              
                              // Reviews Section
                              _buildReviewsSection(reviewCount),
                              const SizedBox(height: 16),
                              
                              // Open Hours Section with Schedule Popup
                              _buildOpenHoursSection(state),
                              const SizedBox(height: 16),
                              
                              const Text(
                                'Amenities(15)', // Placeholder count
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  _buildAmenityChip(Icons.wifi, 'Wi-Fi'),
                                  _buildAmenityChip(Icons.local_parking, 'Parking'),
                                  _buildAmenityChip(Icons.free_breakfast, 'Free Tea'),
                                  // Add more amenities dynamically if available in API
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Location',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              
                              // Location Map Widget with Debug Logging
                              BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
                                builder: (context, state) {
                                  if (state is WorkspaceDetailsLoaded) {
                                    final workspace = state.workspace;
                                    
                                    // Debug logging for workspace details screen
                                    print('WorkspaceDetailsScreen - Workspace type: ${workspace.runtimeType}');
                                    print('WorkspaceDetailsScreen - Workspace address: ${workspace.address}');
                                    
                                    // Check if workspace is a WorkspaceModel with location
                                    if (workspace is WorkspaceModel) {
                                      print('WorkspaceDetailsScreen - WorkspaceModel location: ${workspace.location}');
                                      if (workspace.location != null) {
                                        print('WorkspaceDetailsScreen - Location latitude: ${workspace.location!.latitude}');
                                        print('WorkspaceDetailsScreen - Location longitude: ${workspace.location!.longitude}');
                                        print('WorkspaceDetailsScreen - Location id: ${workspace.location!.id}');
                                        print('WorkspaceDetailsScreen - Location city: ${workspace.location!.city}');
                                        print('WorkspaceDetailsScreen - Location country: ${workspace.location!.country}');
                                        
                                        return LocationMapWidget(
                                          latitude: workspace.location!.latitude,
                                          longitude: workspace.location!.longitude,
                                          address: workspace.address,
                                          height: 200,
                                          borderRadius: 12,
                                        );
                                      } else {
                                        print('WorkspaceDetailsScreen - Location is null');
                                        // Fallback for workspace without location data
                                        return LocationMapWidget(
                                          latitude: null,
                                          longitude: null,
                                          address: workspace.address,
                                          height: 200,
                                          borderRadius: 12,
                                        );
                                      }
                                    } else {
                                      print('WorkspaceDetailsScreen - Workspace is not WorkspaceModel, type: ${workspace.runtimeType}');
                                      // Fallback for non-WorkspaceModel entities
                                      return LocationMapWidget(
                                        latitude: null,
                                        longitude: null,
                                        address: workspace.address,
                                        height: 200,
                                        borderRadius: 12,
                                      );
                                    }
                                  }
                                  // Loading state
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is WorkspaceDetailsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(child: Text('Select a workspace to view details.'));
                  }
                },
              ),
            ),

            // // Bottom Navigation Bar
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade800,
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   margin: const EdgeInsets.all(16),
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       _buildNavItem(0, Icons.home, 'Home'),
            //       _buildNavItem(1, Icons.search, 'Search'),
            //       _buildNavItem(2, Icons.calendar_today, 'Booking'),
            //       _buildNavItem(3, Icons.favorite, 'Favorit'),
            //       _buildNavItem(4, Icons.person, 'Account'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black54),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      backgroundColor: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

