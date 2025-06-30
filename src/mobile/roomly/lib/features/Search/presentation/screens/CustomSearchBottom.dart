import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/Search/presentation/screens/FilterItems.dart';
import 'package:roomly/features/Search/presentation/screens/RoomsSection.dart';
import 'package:roomly/features/Search/presentation/screens/workSpaceSection.dart';
import 'package:roomly/features/Search/presentation/screens/filter_popup_screen.dart';
import 'package:roomly/features/Search/presentation/cubit/search_cubit.dart';
import 'package:roomly/features/Search/domain/entities/search_result.dart';
import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
import '../../domain/entities/recommendation.dart';
import '../../data/models/recommendation_model.dart';

class CustomSearchBottomSheet extends StatefulWidget {
  const CustomSearchBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomSearchBottomSheet> createState() =>
      _CustomSearchBottomSheetState();
}

class _CustomSearchBottomSheetState extends State<CustomSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initUserAndFetchRecommendations();
  }

  Future<void> _initUserAndFetchRecommendations() async {
    final userId = await SecureStorage.getId();
    if (userId != null) {
      setState(() => _userId = userId);
      context.read<SearchCubit>().fetchEnrichedRecommendations(userId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.90,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row with Close Button and Search Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Search",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            // Search Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for workspaces, rooms, or desks...",
                hintStyle: const TextStyle(
                    color:
                        Color.fromARGB(85, 0, 0, 0)), // Change hint text color
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(85, 0, 0, 0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: (value) {
                // Trigger search when user types
                context.read<SearchCubit>().search(value);
              },
            ),
            const SizedBox(height: 16),
            // Filters Row with Filter Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    final hasActiveFilters = state is FilterLoaded;
                    return ElevatedButton.icon(
                      icon: Icon(
                        hasActiveFilters
                            ? Icons.filter_list_off
                            : Icons.filter_list,
                        color: hasActiveFilters ? Colors.white : Colors.white,
                      ),
                      label:
                          Text(hasActiveFilters ? 'Filters Applied' : 'Filter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasActiveFilters ? Colors.green : Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                      onPressed: () {
                        // Get the SearchCubit from the current context
                        final searchCubit = context.read<SearchCubit>();
                        // Show filter popup as modal bottom sheet with proper BlocProvider
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => BlocProvider.value(
                            value: searchCubit,
                            child: const FilterPopupScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                // const Expanded(
                //   child: FiltersSection(),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Results
            Expanded(
              child: BlocConsumer<SearchCubit, SearchState>(
                listener: (context, state) {
                  // Handle state changes if needed
                  if (state is FilterLoaded) {
                    // Filter was applied successfully
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Found ${state.filteredRooms.length} rooms matching your filters'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    return _buildSearchResults(state.searchResult);
                  } else if (state is FilterLoaded) {
                    return _buildFilteredResults(state.filteredRooms);
                  } else if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<SearchCubit>()
                                  .search(_searchController.text);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (_searchController.text.isEmpty &&
                      state is EnrichedRecommendationsLoaded) {
                    return RecommendationsWidget(
                        enrichedRecommendations: state.enrichedRecommendations);
                  } else if (_searchController.text.isEmpty &&
                      state is RecommendationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_searchController.text.isEmpty &&
                      state is RecommendationsError) {
                    return const Center(
                        child: Text('Failed to load recommendations'));
                  } else {
                    return const Center(
                      child: Text(
                        'Start typing to search for workspaces and rooms',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchResult searchResult) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchResult.workspaces.isNotEmpty) ...[
            const Text(
              "Workspaces",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Horizontal scrollable section for WorkspaceResultCard
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: searchResult.workspaces.map((workspace) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: WorkspaceResultCard(
                      imageUrl: workspace.workspaceImages?.isNotEmpty == true
                          ? workspace.workspaceImages!.first.imageUrl
                          : "https://i.pinimg.com/736x/45/01/b0/4501b0f6bad0e29cdadb7e0a329ce9ca.jpg",
                      distance: "5.3", // You might want to calculate this
                      workspaceName: workspace.name,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (searchResult.rooms.isNotEmpty) ...[
            const Text(
              "Rooms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Vertical section for RoomResultCard
            ...searchResult.rooms.map((room) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RoomResultCard(
                  imageUrl: room.roomImages?.isNotEmpty == true
                      ? room.roomImages!.first.imageUrl
                      : "https://i.pinimg.com/736x/94/1e/89/941e8944db3e73b4248cefbcd9b45241.jpg",
                  title: room.name,
                  workspaceName: "in ${room.type} workspace",
                  details:
                      "${room.capacity} Seats . ${room.pricePerHour.toStringAsFixed(0)} EGP/Hour",
                  price: "${room.pricePerHour.toStringAsFixed(2)} EGP/Hour",
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilteredResults(List<Room> filteredRooms) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filtered Rooms",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                },
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear Filters'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (filteredRooms.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No rooms found matching your filters',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try adjusting your filter criteria',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredRooms.map((room) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RoomResultCard(
                  imageUrl: room.roomImages?.isNotEmpty == true
                      ? room.roomImages!.first.imageUrl
                      : "https://i.pinimg.com/736x/94/1e/89/941e8944db3e73b4248cefbcd9b45241.jpg",
                  title: room.name,
                  workspaceName: "in ${room.type} workspace",
                  details:
                      "${room.capacity} Seats . ${room.pricePerHour.toStringAsFixed(0)} EGP/Hour",
                  price: "${room.pricePerHour.toStringAsFixed(2)} EGP/Hour",
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class RecommendationsWidget extends StatelessWidget {
  final List<EnrichedRecommendationModel> enrichedRecommendations;
  const RecommendationsWidget({Key? key, required this.enrichedRecommendations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enrichedRecommendations.isEmpty) {
      return const Center(child: Text('No recommendations found.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recommended for you',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: enrichedRecommendations.length,
            itemBuilder: (context, index) {
              final enriched = enrichedRecommendations[index];
              final rec = enriched.recommendation;
              final workspace = enriched.workspace;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: (workspace.workspaceImages != null &&
                                workspace.workspaceImages!.isNotEmpty)
                            ? Image.network(
                                workspace.workspaceImages!.first.imageUrl,
                                width: 90,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 70,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image,
                                        size: 40, color: Colors.grey),
                                  );
                                },
                              )
                            : Container(
                                width: 90,
                                height: 70,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image,
                                    size: 40, color: Colors.grey),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workspace.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Description and amenities are commented out by user
                            Text('Type:  ${workspace.type}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            Text('Rating: ${workspace.avgRating}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            Text('Price Range: ${rec.priceRange}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
