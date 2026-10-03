import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 🔥 Maps link open karne ke liye package

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  // --- 🗺️ GOOGLE MAPS OPEN KARNE KA FUNCTION ---
  Future<void> _openGoogleMaps(BuildContext context) async {
    const String urlString = "https://maps.app.goo.gl/ZXcBkEK7C487T2JJ6?g_st=aw";
    final Uri mapUri = Uri.parse(urlString);

    try {
      // Pehle check karega ki link launch ho sakti hai ya nahi
      if (await canLaunchUrl(mapUri)) {
        await launchUrl(
          mapUri,
          mode: LaunchMode.externalApplication, // Isse direct Maps app ya browser khulega
        );
      } else {
        throw 'Could not launch maps';
      }
    } catch (e) {
      // Agar kisi wajah se fail hota hai toh user ko error message dikha dega
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open maps. Please try again later."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

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
        iconTheme: const IconThemeData(color: gold),
        title: const Text(
          "Shop Location 📍",
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gold,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: gold,
                    size: 70,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Shubham Hair Salon 👑",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gold,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ListTile(
                    leading: Icon(
                      Icons.place,
                      color: gold,
                    ),
                    title: Text(
                      "Veral Naka, Bhanvad, Gujarat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Near Shubham Hair Salon",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  const ListTile(
                    leading: Icon(
                      Icons.access_time,
                      color: gold,
                    ),
                    title: Text(
                      "Opening Hours",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "09:00 AM - 10:00 PM\n(11:00 PM if appointments continue)",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  const ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: gold,
                    ),
                    title: Text(
                      "+91 78923 41257",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Call for booking or enquiries",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      // 🔥 Ab click karne par map function run hoga
                      onPressed: () => _openGoogleMaps(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(
                        Icons.map,
                        color: Colors.black,
                      ),
                      label: const Text(
                        "OPEN LOCATION",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Visit us for a premium grooming experience.\nWe are ready to make your style royal 👑",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}