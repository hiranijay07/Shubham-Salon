import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const Color gold = Color(0xffD4AF37);
    const Color black = Color(0xff050505);

    return Scaffold(
      backgroundColor: black,

      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,

        title: const Text(
          "Exclusive Offers",
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// Header
            const Text(
              "Premium Deals For Our Customers",
              style: TextStyle(
                color: gold,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Enjoy exclusive salon rewards designed especially for our valued customers.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            /// Main Offer Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),

                border: Border.all(
                  color: gold,
                  width: 1.5,
                ),

                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha:0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                children: [

                  const Icon(
                    Icons.card_giftcard,
                    color: gold,
                    size: 70,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "BIG OFFER 🎁",
                    style: TextStyle(
                      color: gold,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Buy Any 4 Beauty Products",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Get Any 1 Beauty Product FREE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: const Column(
                      children: [

                        Text(
                          "Available only at Shubham Salon 💈",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "This offer is valid only for products purchased directly from our salon shop. Online shopping is not available for this offer.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Shop More • Save More • Look Better",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Future Ready Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold),
              ),

              child: const Row(
                children: [

                  Icon(
                    Icons.campaign,
                    color: gold,
                    size: 35,
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      "More exciting offers and festival discounts are coming soon.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}