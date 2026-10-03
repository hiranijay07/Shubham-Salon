import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  DateTime? selectedDate;
  bool isUpdateMode = false; // 🟢 Toggle mode (Create vs Update)
  bool isLoading = true;    // 🟢 Loading state jab tak data fetch ho rha hai

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  @override
  void initState() {
    super.initState();
    checkIfProfileExists(); // 🟢 Screen khulte hi check karega
  }

  // 🟢 Check if user data already exists in Firestore
  Future<void> checkIfProfileExists() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          setState(() {
            isUpdateMode = true; // Profile exists, switch to Update mode
            nameController.text = data['name'] ?? '';
            mobileController.text = data['mobile'] ?? '';
            ageController.text = data['age'] ?? '';

            // Date string ko wapas DateTime mein convert karne ke liye split
            if (data['dateOfBirth'] != null && data['dateOfBirth'].toString().contains('/')) {
              List<String> parts = data['dateOfBirth'].toString().split('/');
              selectedDate = DateTime(
                int.parse(parts[2]), // Year
                int.parse(parts[1]), // Month
                int.parse(parts[0]), // Day
              );
            }
          });
        }
      } catch (e) {
        print("Error fetching profile: $e");
      }
    }
    setState(() {
      isLoading = false; // Loading khatam
    });
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveProfile() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      showMessage("Please select your date of birth.");
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage("Please login again.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 🟢 Agar update mode hai toh data .update() hoga, nahi toh .set() hoga
      if (isUpdateMode) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text.trim(),
          'mobile': mobileController.text.trim(),
          'age': ageController.text.trim(),
          'dateOfBirth':
          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
          'updatedAt': Timestamp.now(), // Track update time
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'name': nameController.text.trim(),
          'mobile': mobileController.text.trim(),
          'age': ageController.text.trim(),
          'dateOfBirth':
          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
          'email': user.email ?? "",
          'memberSince': DateTime.now().year,
          'createdAt': Timestamp.now(),
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage(
        "Failed to save profile.\nPlease try again.",
      );
      return;
    }

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Text(
            isUpdateMode ? "Profile Updated" : "Profile Created", // 🟢 Dynamic Title
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            isUpdateMode
                ? "Your profile changes have been saved successfully."
                : "Welcome to Shubham Salon.\nYour profile has been created successfully.", // 🟢 Dynamic Content
            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (!isUpdateMode) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    isUpdateMode = true; // Update mode active rakhein
                  });
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
              ),

              child: const Text(
                "Continue",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: black,
          title: Text(
            "Incomplete Profile",
            style: TextStyle(color: gold),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
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
        iconTheme: IconThemeData(color: gold),
        title: Text(
          isUpdateMode ? "Update Profile" : "Create Profile", // 🟢 Dynamic AppBar Title
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator(color: gold)) // 🟢 Loading Spinner data fetch hote waqt
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              CircleAvatar(
                radius: 55,
                backgroundColor: gold,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              buildField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your full name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              buildField(
                controller: mobileController,
                label: "Mobile Number",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "Please enter mobile number";
                  }

                  if (value.length != 10) {
                    return "Mobile number must contain exactly 10 digits";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              buildField(
                controller: ageController,
                label: "Age",
                icon: Icons.cake,
                keyboard: TextInputType.number,
                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "Please enter age";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              ListTile(
                tileColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: gold),
                ),

                leading: Icon(
                  Icons.calendar_month,
                  color: gold,
                ),

                title: Text(
                  selectedDate == null
                      ? "Select Date of Birth"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  style: TextStyle(
                    color: selectedDate == null
                        ? Colors.white70
                        : Colors.white,
                  ),
                ),

                onTap: pickDate,
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: gold),
                ),

                child: Text(
                  "Member Since: ${DateTime.now().year}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: Text(
                    isUpdateMode ? "UPDATE PROFILE" : "CREATE PROFILE", // 🟢 Dynamic Button Text
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: gold),

        prefixIcon: Icon(
          icon,
          color: gold,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold),
          borderRadius: BorderRadius.circular(15),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}