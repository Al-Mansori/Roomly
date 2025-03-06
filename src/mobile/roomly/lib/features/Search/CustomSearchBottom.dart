import 'package:flutter/material.dart';
import 'package:roomly/features/Search/FilterItems.dart';
import 'package:roomly/features/Search/RoomsSection.dart';
import 'package:roomly/features/Search/workSpaceSection.dart';

class CustomSearchBottomSheet extends StatelessWidget {
  const CustomSearchBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.90,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Close Button and Search Input
              Row(
                children: [

                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                  ),
                  Text("Search",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Search Input Field
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for workspaces, rooms, or desks...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (value) {
                  // Handle search input changes
                  print("Search query: $value");
                },
              ),
              SizedBox(height: 16),
              FiltersSection(),
              SizedBox(height: 16),
              Text(
                "Workspaces",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Horizontal scrollable section for WorkspaceResultCard
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    WorkspaceResultCard(
                      imageUrl:
                      "https://i.pinimg.com/736x/45/01/b0/4501b0f6bad0e29cdadb7e0a329ce9ca.jpg",
                      distance: "5.3",
                      workspaceName: "Cozy Workspace",
                    ),
                    SizedBox(width: 20),
                    WorkspaceResultCard(
                      imageUrl:
                      "https://i.pinimg.com/736x/97/79/38/97793811512dfde7d01cef874a86ca18.jpg",
                      distance: "3.2",
                      workspaceName: "Modern Office",
                    ),
                    SizedBox(width: 20),
                    WorkspaceResultCard(
                      imageUrl:
                      "https://i.pinimg.com/736x/97/79/38/97793811512dfde7d01cef874a86ca18.jpg",
                      distance: "3.2",
                      workspaceName: "Modern Office",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Vertical section for RoomResultCard
              Column(
                children: [
                  RoomResultCard(
                    imageUrl:
                    "https://i.pinimg.com/736x/94/1e/89/941e8944db3e73b4248cefbcd9b45241.jpg",
                    title: "Desk",
                    workspaceName: "in workspace-name",
                    details: "30 Seats . 10.0 KM away",
                    price: "70.00EGP/Hour",
                  ),
                  SizedBox(height: 20),
                  RoomResultCard(
                    imageUrl:
                    "https://i.pinimg.com/736x/94/1e/89/941e8944db3e73b4248cefbcd9b45241.jpg",
                    title: "Desk",
                    workspaceName: "in workspace-name",
                    details: "30 Seats . 10.0 KM away",
                    price: "70.00EGP/Hour",
                  ),
                  SizedBox(height: 20),
                  RoomResultCard(
                    imageUrl:
                    "https://i.pinimg.com/736x/94/1e/89/941e8944db3e73b4248cefbcd9b45241.jpg",
                    title: "Desk",
                    workspaceName: "in workspace-name",
                    details: "30 Seats . 10.0 KM away",
                    price: "70.00EGP/Hour",
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}