// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
// import 'package:roomly/features/workspace/presentation/cubits/workspace_details_cubit.dart';
// import 'package:roomly/features/workspace/presentation/screens/workspace_listings_screen.dart';

// class WorkspaceDetailsScreen extends StatefulWidget {
//   final String workspaceId;

//   const WorkspaceDetailsScreen({Key? key, required this.workspaceId}) : super(key: key);

//   @override
//   State<WorkspaceDetailsScreen> createState() => _WorkspaceDetailsScreenState();
// }

// class _WorkspaceDetailsScreenState extends State<WorkspaceDetailsScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedIndex = 0; // For bottom navigation bar

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         setState(() {
//           // This empty setState is crucial to rebuild the widget tree
//           // and reflect the tab change in TabBarView.
//         });
//       }
//     });
//     context.read<WorkspaceDetailsCubit>().getWorkspaceDetails(widget.workspaceId);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with logo and navigation
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Row(
//                 children: [
//                   // Back button
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back_ios, size: 18),
//                       onPressed: () {
//                         context.pop(); // Go back using GoRouter
//                       },
//                     ),
//                   ),
//                   const Spacer(),
//                   // Favorite and share buttons
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.favorite_border, size: 18),
//                       onPressed: () {
//                         // Favorite action
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.share, size: 18),
//                       onPressed: () {
//                         // Share action
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Logo
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Column(
//                 children: [
//                   // Hexagon logo
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.orange,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.hexagon_outlined,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // CUBE SPACE text
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'CUBE',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'SPACE',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Dots indicator (optional, based on image, might be for carousel)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(4, (index) {
//                 return Container(
//                   width: 8,
//                   height: 8,
//                   margin: const EdgeInsets.symmetric(horizontal: 2),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: index == 0 ? Colors.grey : Colors.grey.shade300,
//                   ),
//                 );
//               }),
//             ),

//             const SizedBox(height: 16),

//             // Tab bar
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 indicator: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 1,
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.grey,
//                 tabs: const [
//                   Tab(text: 'WorkSpace Listings'),
//                   Tab(text: 'WorkSpace Details'),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             Expanded(
//               child: BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
//                 builder: (context, state) {
//                   if (state is WorkspaceDetailsLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is WorkspaceDetailsLoaded) {
//                     final WorkspaceEntity workspace = state.workspace;
//                     return TabBarView(
//                       controller: _tabController,
//                       children: [
//                         // Workspace Listings Tab
//                         const WorkspaceListingsScreen(),

//                         // Workspace Details Tab
//                         SingleChildScrollView(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 workspace.name,
//                                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '${workspace.address ?? 'N/A'}', // Placeholder for distance
//                                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   const Icon(Icons.star, size: 16, color: Colors.amber),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '${workspace.avgRating?.toStringAsFixed(1) ?? 'N/A'}',
//                                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'About Workspace',
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 workspace.description ?? 'No description available.',
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Open Hours',
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               const Row(
//                                 children: [
//                                   Icon(Icons.access_time, size: 16, color: Colors.grey),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     'Today: 10:00 am - 11:59 pm', // Placeholder
//                                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Amenities(15)', // Placeholder count
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               Wrap(
//                                 spacing: 8.0,
//                                 runSpacing: 8.0,
//                                 children: [
//                                   _buildAmenityChip(Icons.wifi, 'Wi-Fi'),
//                                   _buildAmenityChip(Icons.local_parking, 'Parking'),
//                                   _buildAmenityChip(Icons.free_breakfast, 'Free Tea'),
//                                   // Add more amenities dynamically if available in API
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Location',
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               // Placeholder for map image
//                               Container(
//                                 height: 200,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade200,
//                                   borderRadius: BorderRadius.circular(8),
//                                   image: const DecorationImage(
//                                     image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF3Q50EAiE9A_I_KEpe9RET3m8tMuXQLed7Q&s'), // Replace with actual map image if available
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 '${workspace.address ?? 'N/A'}',
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               const SizedBox(height: 16),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   } else if (state is WorkspaceDetailsError) {
//                     return Center(child: Text('Error: ${state.message}'));
//                   } else {
//                     return const Center(child: Text('Select a workspace to view details.'));
//                   }
//                 },
//               ),
//             ),

//             // Bottom Navigation Bar
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade800,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNavItem(0, Icons.home, 'Home'),
//                   _buildNavItem(1, Icons.search, 'Search'),
//                   _buildNavItem(2, Icons.calendar_today, 'Booking'),
//                   _buildNavItem(3, Icons.favorite, 'Favorit'),
//                   _buildNavItem(4, Icons.person, 'Account'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAmenityChip(IconData icon, String label) {
//     return Chip(
//       avatar: Icon(icon, size: 18, color: Colors.black54),
//       label: Text(label, style: const TextStyle(fontSize: 14)),
//       backgroundColor: Colors.grey.shade200,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     );
//   }

//   Widget _buildNavItem(int index, IconData icon, String label) {
//     final isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? Colors.white : Colors.grey,
//             size: 24,
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// v2 -----------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/workspace/domain/entities/workspace_entity.dart';
import 'package:roomly/features/workspace/presentation/cubits/workspace_details_cubit.dart';
import 'package:roomly/features/workspace/presentation/screens/workspace_listings_screen.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';
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
  PageController _pageController = PageController();
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
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildImageCarousel(List<dynamic> images) {
    if (images.isEmpty) {
      // Fallback to original logo if no images
      return _buildDefaultLogo();
    }

    return Column(
      children: [
        // Image carousel
        Container(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              final imageUrl = images[index].imageUrl;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _currentImageIndex ? Colors.orange : Colors.grey.shade300,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDefaultLogo() {
    return Column(
      children: [
        // Roomly small SVG logo
        SvgPicture.asset(
          'assets/images/roomly_small.svg',
          width: 120,
          height: 120,
        ),
        const SizedBox(height: 12),
        // Static dots for default logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 0 ? Colors.grey : Colors.grey.shade300,
              ),
            );
          }),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                      onPressed: () {
                        context.pop(); // Go back using GoRouter
                      },
                    ),
                  ),
                  const Spacer(),
                  // Favorite and share buttons
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, size: 18),
                      onPressed: () {
                        // Favorite action
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, size: 18),
                      onPressed: () {
                        // Share action
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Image carousel or logo section
            BlocBuilder<WorkspaceDetailsCubit, WorkspaceDetailsState>(
              builder: (context, state) {
                if (state is WorkspaceDetailsLoaded) {
                  final workspace = state.workspace;
                  // Check if workspace is a WorkspaceModel with images
                  if (workspace is WorkspaceModel && 
                      workspace.workspaceImages != null && 
                      workspace.workspaceImages!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _buildImageCarousel(workspace.workspaceImages!),
                    );
                  }
                }
                // Fallback to default logo
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _buildDefaultLogo(),
                );
              },
            ),

            const SizedBox(height: 16),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'WorkSpace Listings'),
                  Tab(text: 'WorkSpace Details'),
                ],
              ),
            ),

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
                              
                              const Text(
                                'Open Hours',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    'Today: 10:00 am - 11:59 pm', // Placeholder
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
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
                              // Placeholder for map image
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF3Q50EAiE9A_I_KEpe9RET3m8tMuXQLed7Q&s'), // Replace with actual map image if available
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${workspace.address ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
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

            // Bottom Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.search, 'Search'),
                  _buildNavItem(2, Icons.calendar_today, 'Booking'),
                  _buildNavItem(3, Icons.favorite, 'Favorit'),
                  _buildNavItem(4, Icons.person, 'Account'),
                ],
              ),
            ),
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

