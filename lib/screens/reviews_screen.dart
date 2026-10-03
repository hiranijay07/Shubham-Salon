import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController reviewController = TextEditingController();

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  // Shuruat me 0 rakha hai taaki user ko star select karna farjiyat (mandatory) ho jaye
  int selectedRating = 0;

  Future<void> submitReview() async {
    // 1. Star Rating Validation (Farjiyat)
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please select at least 1 star rating."),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    // 2. Text Box Validation (Farjiyat)
    if (reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please write your review text."),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      // User ka name nikalne ke liye logic
      String username = user?.displayName ?? "";
      if (username.isEmpty && user?.email != null) {
        username = user!.email!.split('@')[0]; // Agar naam na ho toh email ka prefix le lega
      }
      if (username.isEmpty) {
        username = "Valued Customer";
      }

      await FirebaseFirestore.instance.collection('reviews').add({
        "userId": user?.uid ?? "",
        "username": username, // Username database me save ho raha hai
        "email": user?.email ?? "",
        "rating": selectedRating,
        "review": reviewController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thank you for your review ❤️"),
          backgroundColor: Colors.green,
        ),
      );

      // State reset karne ke liye taaki dubara submit ke liye clean ho jaye
      setState(() {
        reviewController.clear();
        selectedRating = 0;
      });

      // Keyboard close karne ke liye
      FocusScope.of(context).unfocus();

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting review: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: IconThemeData(color: gold),
        title: Text(
          "Rate Shubham Salon",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Upper Input Form Part
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "How was your experience?",
                      style: TextStyle(
                        color: gold,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Star Selection Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            index < selectedRating ? Icons.star : Icons.star_border,
                            color: gold,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Review TextField
                  TextField(
                    controller: reviewController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write your review here...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: gold),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: gold, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "SUBMIT REVIEW",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // --- CUSTOMER REVIEWS HEADING ---
                  Row(
                    children: [
                      Icon(Icons.rate_review_rounded, color: gold, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Customer Reviews",
                        style: TextStyle(
                          color: gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20, thickness: 1),
                  const SizedBox(height: 10),

                  // --- REVIEWS LIST STREAM ---
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('reviews')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xffD4AF37)),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "No reviews yet. Be the first to review!",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        );
                      }

                      final reviewsDocs = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviewsDocs.length,
                        itemBuilder: (context, index) {
                          final data = reviewsDocs[index].data() as Map<String, dynamic>;

                          final String displayUser = data['username'] ?? 'Anonymous';
                          final int rating = data['rating'] ?? 5;
                          final String reviewText = data['review'] ?? '';

                          // Date Formatting Logic
                          String formattedDate = "Just now";
                          if (data['createdAt'] != null) {
                            final Timestamp timestamp = data['createdAt'] as Timestamp;
                            final DateTime dateTime = timestamp.toDate();
                            formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: gold.withOpacity(0.4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Stars Row
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < rating ? Icons.star : Icons.star_border,
                                      color: gold,
                                      size: 18,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),

                                // 2. User Name
                                Text(
                                  displayUser,
                                  style: TextStyle(
                                    color: gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // 3. Review Text
                                Text(
                                  reviewText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // 4. Date
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}