
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../GlobalWidgets/navBar.dart';
import 'RoomsForOngoing.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward ||
        _scrollController.position.atEdge) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

  final List<String> tabs = ["Upcoming", "On-going", "Pending", "History"];
  int selectedTab = 1; // "On-going" selected by default
  Widget _getContent() {
    switch (selectedTab) {
      case 0:
        return const Center(child: Text("Upcoming Content"));
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Now",
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20,
                ),

              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MeetingRoomCard(
                      title: room['title'] ?? 'No Title',
                      description: room['description'] ?? 'No Description',
                      distance: room['distance'] ?? 'Unknown Distance',
                      imageUrl: room['imageUrl'] ??
                          'https://placehold.co/108x90',
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 2:
        return const Center(child: Text("Pending Content"));
      case 3:
        return const Center(child: Text("History Content"));
      default:
        return const Center(child: Text("No Content"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        tabs.length,
                            (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selectedTab == index ? Colors.white : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: selectedTab == index ? Colors.black : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is UserScrollNotification) {
                      if (scrollInfo.direction == ScrollDirection.reverse) {
                        setState(() => _isNavVisible = false);
                      } else if (scrollInfo.direction == ScrollDirection.forward) {
                        setState(() => _isNavVisible = true);
                      }
                    }
                    return true;
                  },
                  child: _getContent(),
                ),
              ),
            ],
          ),

          // Bottom Navigation Bar - Ensuring it is fixed to the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? -100 : (_isNavVisible ? 0 : -80),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isNavVisible && MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
                child: BottomNavBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
final List<Map<String, String>> rooms = [
  {
    'title': 'Meeting Room (2 people)',
    'description': '2 rooms - business, gaming, studying workspace',
    'distance': '12.5 km away',
    'imageUrl': 'https://i.pinimg.com/736x/b5/20/1f/b5201f3e344db3f23249a9742a8897d5.jpg',
  },
  {
    'title': 'Executive Meeting Room',
    'description': 'Spacious and fully equipped for business meetings',
    'distance': '8 km away',
    'imageUrl': 'https://i.pinimg.com/736x/b5/20/1f/b5201f3e344db3f23249a9742a8897d5.jpg',
  },
  {
    'title': 'Creative Space',
    'description': 'Ideal for brainstorming and team discussions',
    'distance': '5 km away',
    'imageUrl': 'https://i.pinimg.com/736x/b5/20/1f/b5201f3e344db3f23249a9742a8897d5.jpg',
  },
  {
    'title': 'Creative Space',
    'description': 'Ideal for brainstorming and team discussions',
    'distance': '5 km away',
    'imageUrl': 'https://i.pinimg.com/736x/b5/20/1f/b5201f3e344db3f23249a9742a8897d5.jpg',
  },
  {
    'title': 'Creative Space',
    'description': 'Ideal for brainstorming and team discussions',
    'distance': '5 km away',
    'imageUrl': 'https://i.pinimg.com/736x/b5/20/1f/b5201f3e344db3f23249a9742a8897d5.jpg',
  },
  {
    'title': 'Creative Space',
    'description': 'Ideal for brainstorming and team discussions',
    'distance': '5 km away',
    'imageUrl': 'https://i.pinimg.com/736x/b5/20/1f/b5201f3e344db3f23249a9742a8897d5.jpg',
  },

];
