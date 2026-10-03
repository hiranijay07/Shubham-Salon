import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageReviewsScreen extends StatelessWidget {
  const ManageReviewsScreen({super.key});

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  void _deleteReview(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('reviews').doc(docId).delete();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Review removed successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete review: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: IconThemeData(color: gold),
        elevation: 0,
        title: Text(
          "Manage Reviews",
          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffD4AF37)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No feedback reviews posted yet.", style: TextStyle(color: Colors.white54)),
            );
          }

          final reviewDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: reviewDocs.length,
            itemBuilder: (context, index) {
              final doc = reviewDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              final String displayUser = data['username'] ?? 'Anonymous';
              final int rating = data['rating'] ?? 5;
              final String reviewText = data['review'] ?? '';

              String formattedDate = "Just now";
              if (data['createdAt'] != null) {
                final Timestamp timestamp = data['createdAt'] as Timestamp;
                final DateTime dateTime = timestamp.toDate();
                formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: gold.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayUser,
                          style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialContext) => AlertDialog(
                                backgroundColor: black,
                                title: Text("Delete Review?", style: TextStyle(color: gold)),
                                content: const Text("Are you sure you want to delete this review comment?", style: TextStyle(color: Colors.white)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialContext),
                                    child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(dialContext);
                                      _deleteReview(context, doc.id);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                    child: const Text("Delete", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < rating ? Icons.star : Icons.star_border,
                          color: gold,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reviewText,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}