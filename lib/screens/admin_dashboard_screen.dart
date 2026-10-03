import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Note: In files ko hum next steps me banayenge, tab tak ye imports error de sakte hain.
// Aap chahein toh pehle file create kar sakte hain ya abhi inko comment kar sakte hain.
import 'manage_bookings_screen.dart';
import 'manage_reviews_screen.dart';
import 'manage_gallery_screen.dart';
import 'manage_services_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  @override
  Widget build(BuildContext context) {
    // Current date format matching your booking layout: "D/M/YYYY"
    final DateTime now = DateTime.now();
    final String todayString = "${now.day}/${now.month}/${now.year}";

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: gold),
            onPressed: () {
              // Standard route reversal back to Login
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back, Admin",
              style: TextStyle(
                color: gold,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Here is the realtime operational overview for Shubham Salon.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 25),

            // --- METRICS GRID SECTION ---
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2,
              children: [
                // 1. Total Users Counter
                _buildStatCard(
                  title: "Total Users",
                  icon: Icons.people_alt_rounded,
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                ),
                // 2. Total Bookings Counter
                _buildStatCard(
                  title: "Total Bookings",
                  icon: Icons.book_online_rounded,
                  stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
                ),
                // 3. Today's Appointments Counter
                _buildStatCard(
                  title: "Today's Appts",
                  icon: Icons.calendar_today_rounded,
                  stream: FirebaseFirestore.instance
                      .collection('bookings')
                      .where('date', isEqualTo: todayString)
                      .snapshots(),
                ),
                // 4. Total Reviews Counter
                _buildStatCard(
                  title: "Total Reviews",
                  icon: Icons.star_rate_rounded,
                  stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // --- MANAGEMENT NAVIGATION CONTROLS ---
            Text(
              "Management Modules",
              style: TextStyle(
                color: gold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            _buildMenuTile(
              context,
              title: "Manage Appointments",
              subtitle: "View, confirm, complete, or cancel bookings",
              icon: Icons.date_range_rounded,
              destination: const ManageBookingsScreen(),
            ),
            _buildMenuTile(
              context,
              title: "Manage Reviews",
              subtitle: "Monitor feedback and user ratings",
              icon: Icons.rate_review_rounded,
              destination: const ManageReviewsScreen(),
            ),
            _buildMenuTile(
              context,
              title: "Manage Gallery",
              subtitle: "Update showcase lookbook and portfolio photos",
              icon: Icons.collections_rounded,
              destination: const ManageGalleryScreen(),
            ),
            _buildMenuTile(
              context,
              title: "Manage Services",
              subtitle: "Add, modify, or remove salon catalog items",
              icon: Icons.content_cut_rounded,
              destination: const ManageServicesScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper builder for metric grid items
  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Stream<QuerySnapshot> stream,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: gold, size: 28),
              const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              String count = "0";
              if (snapshot.hasData) {
                count = snapshot.data!.docs.length.toString();
              }
              return Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Helper builder for menu option layout
  Widget _buildMenuTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Widget destination,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withOpacity(0.5), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: gold, size: 28),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: gold, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}