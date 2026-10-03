import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xffD4AF37);
    const Color black = Color(0xff050505);

    return Scaffold(
      backgroundColor: black,

      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications 🔔",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          notificationCard(
            icon: Icons.check_circle,
            title: "Booking Confirmed",
            subtitle:
            "Your appointment has been confirmed successfully.",
            time: "5 min ago",
          ),

          const SizedBox(height: 15),

          notificationCard(
            icon: Icons.access_time_filled,
            title: "Appointment Reminder",
            subtitle:
            "Reminder: Your appointment is scheduled for tomorrow at 10:00 AM.",
            time: "1 hour ago",
          ),

          const SizedBox(height: 15),

          notificationCard(
            icon: Icons.local_offer,
            title: "Special Offer 🎁",
            subtitle:
            "Buy any 4 beauty products and get 1 beauty product FREE at shop.",
            time: "Today",
          ),

          const SizedBox(height: 15),

          notificationCard(
            icon: Icons.store,
            title: "Shop Timing",
            subtitle:
            "Shubham Hair Salon is open daily from 9:00 AM to 10:00 PM.",
            time: "Today",
          ),

          const SizedBox(height: 15),

          notificationCard(
            icon: Icons.workspace_premium,
            title: "Groom Special Package 👑",
            subtitle:
            "Wedding Groom Styling and Premium Groom Makeover now available.",
            time: "Yesterday",
          ),

          const SizedBox(height: 15),

          notificationCard(
            icon: Icons.content_cut,
            title: "New Service Added",
            subtitle:
            "Cleanup and Detan Treatment services are now available.",
            time: "2 days ago",
          ),
        ],
      ),
    );
  }

  Widget notificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    const Color gold = Color(0xffD4AF37);

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gold,
          width: 1.5,
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: gold.withValues(alpha:0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: gold,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}