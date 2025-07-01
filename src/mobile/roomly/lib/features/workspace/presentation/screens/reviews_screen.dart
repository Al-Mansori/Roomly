import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/workspace/domain/entities/review_entity.dart';
import 'package:roomly/features/workspace/presentation/cubits/reviews_cubit.dart';

import '../../../GlobalWidgets/app_session.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ReviewsScreen extends StatefulWidget {
  final String workspaceId;
  const ReviewsScreen({Key? key, required this.workspaceId}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_updateSendButtonState);
    context.read<ReviewsCubit>().getReviews(widget.workspaceId);
  }

  @override
  void dispose() {
    _commentController.removeListener(_updateSendButtonState);
    _commentController.dispose();
    super.dispose();
  }

  void _updateSendButtonState() {
    setState(() {
      _isSendButtonEnabled = _commentController.text.isNotEmpty && _selectedRating > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Reviews',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews list
          Expanded(
            child: BlocBuilder<ReviewsCubit, ReviewsState>(
              builder: (context, state) {
                if (state is ReviewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ReviewsLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.reviews.length,
                    itemBuilder: (context, index) {
                      final review = state.reviews[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildReviewCard(review),
                      );
                    },
                  );
                } else if (state is ReviewsError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No reviews yet.'));
              },
            ),
          ),
          // Rating stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = index + 1;
                    _updateSendButtonState();
                  });
                },
                child: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 32,
                ),
              );
            }),
          ),

          // Add comment title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              'Add Comment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Comment input
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    IconButton(
                      icon: Icon(Icons.send, color: _isSendButtonEnabled ? Colors.blue : Colors.grey),
                      onPressed: _isSendButtonEnabled ? () {
                        // Send comment
                        _submitReview();
                      } : null,
                    ),
                  ],
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewEntity review) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Unknown User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      review.reviewDate,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.star, color: const Color(0xFFFFD700), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // void _submitReview() {
  //   final comment = _commentController.text;
  //   final rating = _selectedRating.toDouble();
  //   final userId = 'usr001'; // TODO: Replace with actual user ID
  //   final workspaceId = widget.workspaceId;

  //   context.read<ReviewsCubit>().submitReview(
  //     comment: comment,
  //     userId: userId,
  //     workspaceId: workspaceId,
  //     rating: rating,
  //   );

  //   // Clear fields after submission
  //   _commentController.clear();
  //   setState(() {
  //     _selectedRating = 0;
  //     _isSendButtonEnabled = false;
  //   });
  // }

  void _submitReview() async { // Made async
    final comment = _commentController.text;
    final rating = _selectedRating.toDouble();
    final UserEntity? user = AppSession().currentUser;

    final userId = user?.id; // Get user ID from secure storage
    final workspaceId = widget.workspaceId;

    if (userId == null) {
      // Handle case where userId is not found, e.g., show an error message
      print('User ID not found in secure storage.');
      return;
    }

    context.read<ReviewsCubit>().submitReview(
      comment: comment,
      userId: userId,
      workspaceId: workspaceId,
      rating: rating,
    );

    // Clear fields after submission
    _commentController.clear();
    setState(() {
      _selectedRating = 0;
      _isSendButtonEnabled = false;
    });
  }
}





