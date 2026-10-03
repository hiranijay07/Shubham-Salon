import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_form_screen.dart';
import 'gallery_screen.dart';
import 'reviews_screen.dart';
import 'settings_screen.dart';
import 'location_screen.dart';
import 'admin_login_screen.dart'; // Admin login ka import link add kiya hai

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Database se aane wala user name
  final String databaseUsername = "Shubham Kumar";

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xffD4AF37);
    const Color black = Color(0xff050505);

    // Firebase Auth se current authenticated user ki details nikalna
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// ---------------- MY PROFILE ----------------
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileFormScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: gold,
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xffD4AF37),
                      child: Icon(
                        Icons.person,
                        size: 55,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "My Profile",
                      style: TextStyle(
                        color: Color(0xffD4AF37),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    /// --- USER NAME FROM DATABASE ---
                    Text(
                      databaseUsername,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tap here to create or manage your profile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xffD4AF37),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// ---------------- BARBER PROFILE ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xffD4AF37),
                      child: Icon(
                        Icons.content_cut,
                        size: 55,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Bhavik Lakhtariya",
                      style: TextStyle(
                        color: gold,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Owner & Senior Barber",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "⭐ 8+ Years Experience",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "✔ Verified Professional Barber",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "🌍 Languages: Gujarati, Hindi, English",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Specialties",
                    style: TextStyle(
                      color: gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("✔ Hair Styling", style: TextStyle(color: Colors.white)),
                  Text("✔ Beard Styling", style: TextStyle(color: Colors.white)),
                  Text("✔ Hair Colour", style: TextStyle(color: Colors.white)),
                  Text("✔ Facial Grooming", style: TextStyle(color: Colors.white)),
                  Text("✔ Cleanup", style: TextStyle(color: Colors.white)),
                  Text("✔ Detan Treatment", style: TextStyle(color: Colors.white)),
                  Text("✔ Skin Care Grooming", style: TextStyle(color: Colors.white)),
                  Text("✔ Groom Special Package", style: TextStyle(color: Colors.white)),
                  Text("✔ Wedding Groom Styling", style: TextStyle(color: Colors.white)),
                  Text("✔ Premium Groom Makeover", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ---------------- REVIEWS LISTTILE ----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: const Icon(
                  Icons.star,
                  color: Color(0xffD4AF37),
                ),
                title: const Text(
                  "Reviews",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReviewScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            /// ---------------- LOCATION LISTTILE ----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: const Icon(
                  Icons.location_on,
                  color: Color(0xffD4AF37),
                ),
                title: const Text(
                  "Shop Location",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            /// ---------------- GALLERY LISTTILE ----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xffD4AF37),
                ),
                title: const Text(
                  "Shop Gallery",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GalleryScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            /// ---------------- SETTINGS LISTTILE ----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: const Icon(
                  Icons.settings,
                  color: Color(0xffD4AF37),
                ),
                title: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ),

            /// ---------------- HIDDEN ADMIN PORTAL ACCESS ----------------
            // Note: Apni sahi admin email ID niche wale quote "" ke andar save kar lijiye.
            if (currentUser != null && currentUser.email == "admin123@gmail.com") ...[
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: gold, width: 1.5), // Premium gold border border
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  leading: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Color(0xffD4AF37),
                  ),
                  title: const Text(
                    "Admin Control Portal",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}