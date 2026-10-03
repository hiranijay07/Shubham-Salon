import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isEmailLogin = true;
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  // 🔥 OTP ke variables jo aapne banaye huye hain
  String verificationId = "";
  bool otpSent = false;
  final otpController = TextEditingController();

  final Color gold = const Color(0xffD4AF37);

  Future<void> login() async {
    if (isEmailLogin) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (!email.contains('@') || !email.contains('.')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email address.")),
        );
        return;
      }

      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password must contain at least 6 characters.")),
        );
        return;
      }

      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        if (!mounted) return;
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Login failed")),
        );
      }
    }
  }

  // 🔥 OTP SEND FUNCTION (Aapka likha hua logic)
  Future<void> sendOTP() async {
    String mobile = mobileController.text.trim();

    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10 digit mobile number.")),
      );
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$mobile",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (!mounted) return;
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "OTP Verification Failed")),
        );
      },
      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        setState(() {
          otpSent = true; // 🟢 Isse screen par OTP ka box shuru ho jayega
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Sent Successfully")),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  // 🔥 OTP VERIFY FUNCTION (Aapka likha hua logic)
  Future<void> verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address first.")),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent to your email 📧")),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong.")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050505),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Icon(Icons.content_cut, size: 90, color: gold),
                const SizedBox(height: 15),
                Text(
                  "SHUBHAM SALON",
                  style: TextStyle(color: gold, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 10),
                const Text("Royal Grooming Experience", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 40),

                // Email / Mobile Selector Tabs
                Container(
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isEmailLogin = true),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isEmailLogin ? gold : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text("Email", textAlign: TextAlign.center, style: TextStyle(color: isEmailLogin ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isEmailLogin = false),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: !isEmailLogin ? gold : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text("Mobile", textAlign: TextAlign.center, style: TextStyle(color: !isEmailLogin ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Form Core UI Conditionally Switching
                if (isEmailLogin) ...[
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(labelText: "Email Address", labelStyle: TextStyle(color: gold)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: gold),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: gold),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: resetPassword,
                      child: Text("Forgot Password?", style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ] else ...[
                  // 📱 Dynamic Mobile Login Interface
                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    enabled: !otpSent, // OTP jaane ke baad mobile number lock ho jayega
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: TextStyle(color: gold),
                        prefixText: "+91 ",
                        prefixStyle: const TextStyle(color: Colors.white)
                    ),
                  ),

                  // 👑 OTP TEXTFIELD: Jo aapko sahi jagah par chahiye tha!
                  if (otpSent) ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Enter 6-Digit OTP",
                        labelStyle: TextStyle(color: gold),
                        counterText: "", // Bottom maxLength character count ko hide karne ke liye
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Mobile Authentication Single Dynamic Trigger Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: otpSent ? verifyOTP : sendOTP, // Sahi dynamic trigger click handle
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        otpSent ? "VERIFY OTP" : "SEND OTP",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ),
                ],

                // Email login action state button handler
                if (isEmailLogin) ...[
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text(
                        "login",
                        style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(color: gold, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}