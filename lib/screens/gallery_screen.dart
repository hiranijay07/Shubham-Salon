import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

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
          "Royal Gallery 👑",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Center(
              child: Text(
                "Explore Our Royal Collection 👑",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: gold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Experience premium grooming and professional styling at Shubham Salon.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 35),

            buildSectionTitle("💈 Salon Interior"),
            const SizedBox(height: 15),

            buildGalleryGrid([
              "assets/images/interior1.jpg",
              "assets/images/interior2.jpg",
              "assets/images/interior3.jpg",
              "assets/images/interior4.jpg",
            ]),

            const SizedBox(height: 30),

            buildSectionTitle("✂ Trending Hairstyles"),
            const SizedBox(height: 15),

            buildGalleryGrid([
              "assets/images/style1.jpg",
              "assets/images/style2.jpg",
              "assets/images/style3.jpg",
              "assets/images/style4.jpg",
            ]),

            const SizedBox(height: 30),

            buildSectionTitle("👑 Groom Special"),
            const SizedBox(height: 15),

            buildGalleryGrid([
              "assets/images/groom1.jpg",
              "assets/images/groom2.jpg",
              "assets/images/groom3.jpg",
              "assets/images/groom4.jpg",
            ]),

            const SizedBox(height: 30),

            buildSectionTitle("🧴 Beauty Products"),
            const SizedBox(height: 15),

            buildGalleryGrid([
              "assets/images/product1.jpg",
              "assets/images/product2.jpg",
              "assets/images/product3.jpg",
              "assets/images/product4.jpg",
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xffD4AF37),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildGalleryGrid(List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: images.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1,
      ),

      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            border: Border.all(
              color: const Color(0xffD4AF37),
              width: 2,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),

            child: Image.asset(
              images[index],
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black,

                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: Color(0xffD4AF37),
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}