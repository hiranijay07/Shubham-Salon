import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔥 Aapke bataye huye saare zaroori imports yahan hain
import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    // 1. Animation Setup (Royal fade effect)
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.forward();

    // 🔥 2. Aapka naya login status method yahan call ho raha hai
    checkLoginStatus();
  }

  // 🔥 3. AAPKA NAYA METHOD JO AAPNE BHEJA HAI 🔥
  Future<void> checkLoginStatus() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050505),
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shubham Salon Logo
              Image.asset(
                "assets/images/logo.png",
                height: 320,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    "SHUBHAM SALON",
                    style: TextStyle(
                      color: Color(0xffD4AF37),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // Golden line glow
              Container(
                width: 150,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xffD4AF37),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffD4AF37).withValues(alpha: 0.8),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Tagline
              const Text(
                "STYLE THAT DEFINES YOU",
                style: TextStyle(
                  color: Color(0xffD4AF37),
                  fontSize: 14,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 40),

              // Premium loader
              const CircularProgressIndicator(
                color: Color(0xffD4AF37),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}