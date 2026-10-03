import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageBookingsScreen extends StatelessWidget {
  const ManageBookingsScreen({super.key});

  final Color gold = const Color(0xffD4AF37);
  final Color black = const Color(0xff050505);

  void _updateStatus(BuildContext context, String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docId)
          .update({'status': newStatus});

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Booking marked as $newStatus successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update status: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: IconThemeData(color: gold),
        elevation: 0,
        title: Text(
          "Manage Bookings",
          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffD4AF37)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No bookings found.", style: TextStyle(color: Colors.white54)),
            );
          }

          final records = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final doc = records[index];
              final data = doc.data() as Map<String, dynamic>;

              final List servicesList = data['services'] ?? [];
              final String bookingDate = data['date'] ?? 'N/A';
              final String bookingTime = data['time'] ?? 'N/A';
              final String userEmail = data['email'] ?? 'N/A';
              final String currentStatus = data['status'] ?? 'Pending';
              final String paymentMethod = data['paymentMethod'] ?? 'N/A';

              Color statusColor = Colors.orangeAccent;
              if (currentStatus == "Confirmed") statusColor = Colors.blueAccent;
              if (currentStatus == "Completed") statusColor = Colors.green;
              if (currentStatus == "Cancelled") statusColor = Colors.redAccent;

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: gold.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$bookingDate | $bookingTime",
                          style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha:0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            currentStatus,
                            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 25),
                    Text("User Email: $userEmail", style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(
                      "Services: ${servicesList.join(', ')}",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Text("Payment: $paymentMethod", style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Update Status:",
                          style: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.black,
                          value: currentStatus,
                          icon: Icon(Icons.edit_attributes_rounded, color: gold),
                          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
                          underline: Container(height: 1, color: gold),
                          onChanged: (String? value) {
                            if (value != null) {
                              _updateStatus(context, doc.id, value);
                            }
                          },
                          items: <String>['Pending', 'Confirmed', 'Completed', 'Cancelled']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}