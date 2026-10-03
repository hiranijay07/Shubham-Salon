import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Invite friends ke share feature ke liye
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  // --- 1. SHARE APP FUNCTION (INVITE FRIENDS) ---
  void _inviteFriends() {
    const String appLink = "https://play.google.com/store/apps/details?id=com.shubhamsalon.app";
    const String shareMessage =
        "✂️ Hey! Look your best with Shubham Hair Salon. Book your premium grooming session now using our Royal Salon App! 🌟\n\nDownload the app here: $appLink";

    Share.share(shareMessage);
  }

  // --- 2. PREMIUM BOTTOM SHEET FOR INFORMATION ---
  void _showInfoBottomSheet({required String title, required List<Widget> content}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xff0d0d0d),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            border: Border.all(color: gold, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: gold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.white24, height: 25, thickness: 1),
              ...content,
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings ⚙️",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// ---------------- SHOP INFORMATION ----------------
          buildTile(
            icon: Icons.store,
            title: "Shop Information",
            subtitle: "Shubham Hair Salon • Since 1986",
            onTap: () {
              _showInfoBottomSheet(
                title: "🏛️ Shubham Hair Salon",
                content: [
                  const Text(
                    "Legacy of 40 Years",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Serving style and confidence since the last 40 years. Our salon is built on trust, exceptional quality, and standard royal treatments.",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Our Team",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "• Total 2 Professional Craftsmen working currently.\n• Both are certified Senior Grooming Specialists with extensive experience.",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Premium Beauty Products",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We use and sell 100% authentic, high-end professional beauty and hair care products right inside the shop.",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 15),

          /// ---------------- PRIVACY POLICY ----------------
          buildTile(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            subtitle: "View application privacy details",
            onTap: () {
              _showInfoBottomSheet(
                title: "🔒 Privacy & Data Protection",
                content: [
                  const Text(
                    "Your Privacy Matters To Us",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "• Data Security: Your profile details, booking schedules, and appointment history are completely secured via encrypted Firebase database layers.\n\n• Account Security: Authentication is managed smoothly via Google/Firebase Auth secure parameters.\n\n• Permitted Usage: We never share your personal contact numbers or booking choices with any third-party agencies.",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 15),

          /// ---------------- ABOUT APP ----------------
          buildTile(
            icon: Icons.info,
            title: "About App",
            subtitle: "Royal Salon Booking App v1.0",
            onTap: () {
              _showInfoBottomSheet(
                title: "👑 Royal Salon App Details",
                content: [
                  const Text(
                    "Smart Digital Grooming Experience",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This application is custom crafted to eliminate waiting times. Experience premium salon services right at your fingertips.",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Core Features Available",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "✔ Quick Profile Setup & Updation\n✔ Smart Live Customer Feedback & Reviews\n✔ Real-Time Salon Location Map Services\n✔ Dynamic Portfolio Showcase Gallery",
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 15),

          /// ---------------- INVITE FRIENDS ----------------
          buildTile(
            icon: Icons.group_add,
            title: "Invite Friends",
            subtitle: "Share app with friends and family",
            onTap: _inviteFriends,
          ),

          const SizedBox(height: 15),

          /// ---------------- LOGOUT ----------------
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 18,
            ),
            onTap: () async {
              bool? result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xff0d0d0d),
                    title: Text("Logout", style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
                    content: const Text("Are you sure you want to logout?", style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("No", style: TextStyle(color: Colors.white54)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Yes", style: TextStyle(color: gold)),
                      ),
                    ],
                  );
                },
              );

              if (result == true) {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
          ),

          const SizedBox(height: 30),

          const Center(
            child: Text(
              "Made with ❤️ for Shubham Hair Salon",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(
                color: gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? gold,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: iconColor ?? gold,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
          ),
        )
            : null,
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 18,
            ),
      ),
    );
  }
}