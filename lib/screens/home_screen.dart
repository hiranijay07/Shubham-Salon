import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  late final List<Widget> pages = [
    const HomeContent(),
    const BookingScreen(),
    const OffersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        title: Text(
          "Shubham Salon",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: black,
        selectedItemColor: gold,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_rounded),
            label: "Offers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HOME CONTENT WIDGET (WITHOUT TIME)
// ==========================================
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xffD4AF37);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thanks For Visit Shubham Salon ",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Welcome to the Royal Grooming Experience",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),

            // Offer Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gold,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "BUY ANY 4 PRODUCTS",
                    style: TextStyle(
                      color: Color(0xffD4AF37),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Get 1 Beauty Product FREE 🎁",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Our Services",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // GridView jisme se 'time' parameter poori tarah hat chuka hai
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.0, // Ratio thoda change kiya h taaki box bina time ke square aur acche dikhein
              children: [
                serviceCard(
                  icon: Icons.cut_rounded,
                  title: "Hair Cut",
                ),
                serviceCard(
                  icon: Icons.face_rounded,
                  title: "Facial",
                ),
                serviceCard(
                  icon: Icons.colorize_rounded,
                  title: "Hair colour",
                ),
                serviceCard(
                  icon: Icons.content_cut_rounded,
                  title: "Beard Tream",
                ),
                serviceCard(
                  icon: Icons.storefront_rounded,
                  title: "Beauty product",
                ),
                serviceCard(
                  icon: Icons.clean_hands_rounded,
                  title: "Manicure",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SERVICE CARD METHOD (NO TIME BOX HERE)
// ==========================================
Widget serviceCard({
  required IconData icon,
  required String title,
}) {
  const Color gold = Color(0xffD4AF37);

  return Container(
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: gold,
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: gold.withValues(alpha:0.15),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 42,
          color: gold,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}