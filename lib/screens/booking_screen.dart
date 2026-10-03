import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  DateTime? selectedDate;
  String selectedPayment = "UPI / GPay";
  String? selectedTime;

  List<String> selectedServices = [];
  List<String> alreadyBookedSlots = [];

  final List<String> services = [
    "Hair Cut",
    "Beard Trim",
    "Hair Colour",
    "Facial",
    "Beauty Products",
    "Groom Special",
  ];

  final List<String> timeSlots = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "02:00 PM",
    "02:30 PM",
    "03:00 PM",
    "03:30 PM",
    "04:00 PM",
    "04:30 PM",
    "05:00 PM",
    "05:30 PM",
    "06:00 PM",
    "06:30 PM",
    "07:00 PM",
  ];

  @override
  void initState() {
    super.initState(); // Pehle super.initState call hona chahiye
    selectedDate = DateTime.now();
    listenToBookedSlots();
  }

  void listenToBookedSlots() {
    if (selectedDate == null) return;

    String bookingDate = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    FirebaseFirestore.instance
        .collection('bookings')
        .where('date', isEqualTo: bookingDate)
        .snapshots()
        .listen((snapshot) {
      List<String> booked = [];
      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('time') && doc['time'] != null) {
          booked.add(doc['time'].toString());
        }
      }
      setState(() {
        alreadyBookedSlots = booked;
        if (selectedTime != null && alreadyBookedSlots.contains(selectedTime)) {
          selectedTime = null;
        }
      });
    });
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
      });
      listenToBookedSlots();
    }
  }

  Future<void> saveBooking() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await FirebaseFirestore.instance
        .collection("bookings")
        .add({
      "userId": user.uid,
      "email": user.email ?? "",
      "services": selectedServices,
      "date":
      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
      "time": selectedTime,
      "paymentMethod": selectedPayment,
      "status": "Pending",
      "createdAt": Timestamp.now(),
    });
  }

  Future<void> cancelBooking(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your appointment has been cancelled successfully."),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error cancelling appointment: $e"),
        ),
      );
    }
  }

  bool isTimeInPast(String timeStr) {
    if (selectedDate == null) return false;

    DateTime now = DateTime.now();
    if (selectedDate!.day != now.day ||
        selectedDate!.month != now.month ||
        selectedDate!.year != now.year) {
      return false;
    }

    try {
      DateFormat format = DateFormat("hh:mm a");
      DateTime parsedTime = format.parse(timeStr);

      DateTime slotDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      return slotDateTime.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: black,

      appBar: AppBar(
        backgroundColor: black,
        title: const Text(
          "Book Appointment",
          style: TextStyle(
            color: Color(0xffD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// SERVICES
            Text(
              "Select Services",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: services.map((service) {

                bool isSelected =
                selectedServices.contains(service);

                return FilterChip(
                  label: Text(service),

                  selected: isSelected,

                  selectedColor: gold,

                  backgroundColor: Colors.black,

                  checkmarkColor: Colors.black,

                  labelStyle: TextStyle(
                    color:
                    isSelected
                        ? Colors.black
                        : Colors.white,
                  ),

                  side: BorderSide(color: gold),

                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedServices.add(service);
                      } else {
                        selectedServices.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// DATE
            Text(
              "Select Date",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: pickDate,

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: gold),
                ),

                child: Text(
                  selectedDate == null
                      ? "Choose Appointment Date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// TIME SLOT
            Text(
              "Select Time Slot",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: timeSlots.map((time) {
                bool isBooked = alreadyBookedSlots.contains(time);
                bool isPast = isTimeInPast(time);
                bool isAvailable = !isBooked && !isPast;

                bool selected = selectedTime == time;

                return ChoiceChip(
                  label: Text(
                    isBooked ? "$time (Booked)" : time,
                  ),

                  selected: selected,

                  onSelected: isAvailable ? (_) {
                    setState(() {
                      selectedTime = time;
                    });
                  } : null,

                  selectedColor: gold,

                  disabledColor: Colors.grey.withOpacity(0.15),
                  backgroundColor: Colors.black,

                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.black
                        : (isAvailable ? Colors.white : Colors.white38),
                    decoration: isAvailable ? TextDecoration.none : TextDecoration.lineThrough,
                  ),

                  side: BorderSide(
                    color: isAvailable ? gold : Colors.grey.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// PAYMENT
            Text(
              "Payment Method",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            RadioListTile(
              value: "UPI / GPay",
              groupValue: selectedPayment,
              activeColor: gold,
              title: const Text(
                "UPI / GPay",
                style: TextStyle(color: Colors.white),
              ),
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),

            RadioListTile(
              value: "Pay at Shop",
              groupValue: selectedPayment,
              activeColor: gold,
              title: const Text(
                "Pay at Shop",
                style: TextStyle(color: Colors.white),
              ),
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            /// SHOP HOURS
            Text(
              "Shop Hours",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gold,
                  width: 1.2,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: gold,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Regular Hours",
                        style: TextStyle(
                          color: gold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "09:00 AM - 10:00 PM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: gold,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Royal Service Extension",
                        style: TextStyle(
                          color: gold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Services may continue until 11:00 PM\nfor ongoing appointments only.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// TODAY APPOINTMENTS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold),
              ),

              child: Column(
                children: [

                  const Text(
                    "Today Appointments",
                    style: TextStyle(
                      color: Color(0xffD4AF37),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .where(
                      'date',
                      isEqualTo:
                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                    )
                        .snapshots(),

                    builder: (context, snapshot) {

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Text(
                          "No Appointments Yet",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }

                      return Column(
                        children: snapshot.data!.docs.map((doc) {

                          Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 5),

                            child: Text(
                              "${data['time']} - ${(data['services'] as List).join(', ')}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// MY APPOINTMENT SECTION
            const SizedBox(height: 30),

            Text(
              "My Appointment",
              style: TextStyle(
                color: gold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {

                  return const Text(
                    "No appointment booked yet.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  );
                }

                var docs = snapshot.data!.docs;
                docs.sort((a, b) {
                  var aTime = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
                  var bTime = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp;
                  return bTime.compareTo(aTime);
                });

                var doc = docs.first;
                String docId = doc.id;
                var data = doc.data() as Map<String, dynamic>;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gold),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Thank you for choosing\nShubham Salon ❤️",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "📅 Date : ${data['date']}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "🕒 Time : ${data['time']}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "✂️ Services : ${(data['services'] as List).join(', ')}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "💳 Payment : ${data['paymentMethod']}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "📌 Status : ${data['status']}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔴 CANCEL BOOKING BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: gold),
                                  ),
                                  title: Text(
                                    "Cancel Appointment?",
                                    style: TextStyle(
                                      color: gold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to cancel this royal grooming session? This action cannot be undone.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "No, Keep It",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await cancelBooking(docId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        "Yes, Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "CANCEL BOOKING",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                onPressed: () async {

                  if (selectedServices.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please select at least one service.",
                        ),
                      ),
                    );
                    return;
                  }

                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please choose an appointment date.",
                        ),
                      ),
                    );
                    return;
                  }

                  if (selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please select an available time slot.",
                        ),
                      ),
                    );
                    return;
                  }

                  if (selectedPayment.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please choose a payment method.",
                        ),
                      ),
                    );
                    return;
                  }

                  String bookingDate =
                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

                  QuerySnapshot existingBooking =
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .where('date', isEqualTo: bookingDate)
                      .where('time', isEqualTo: selectedTime)
                      .get();

                  if (existingBooking.docs.isNotEmpty) {
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: black,
                          title: Text(
                            "Appointment Not Available",
                            style: TextStyle(color: gold),
                          ),
                          content: const Text(
                            "Sorry, this time slot has already been reserved by another customer.\n\nPlease choose another time slot.",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );

                    return;
                  }

                  await saveBooking();

                  if (!mounted) return;
                  showDialog(
                    context: context,
                    barrierDismissible: false,

                    builder: (context) {
                      return Dialog(
                        backgroundColor: const Color(0xff050505),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(25),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffD4AF37).withValues(alpha: 0.15), // Naya `.withValues` method updated
                                ),

                                child: const Icon(
                                  Icons.check_circle,
                                  color: Color(0xffD4AF37),
                                  size: 70,
                                ),
                              ),

                              const SizedBox(height: 25),

                              const Text(
                                "Appointment Confirmed",
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Color(0xffD4AF37),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                "Your royal grooming session\nhas been reserved successfully.",
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 25),

                              Text(
                                "📅 Date : ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "🕒 Time : $selectedTime",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "💳 Payment : $selectedPayment",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "✂️ Services : ${selectedServices.join(', ')}",
                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,
                                height: 55,

                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffD4AF37),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),

                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "CONFIRM BOOKING",
                  style: TextStyle(
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
    );
  }
}