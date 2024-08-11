import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swasth_bharat/features/appointment/appointment_services.dart'; // For date and time formatting

class UserAppointmentScreen extends StatefulWidget {
  static const String routeName = '/userAppointmentScreen';
  final String doctorId;

  UserAppointmentScreen({required this.doctorId});

  @override
  _UserAppointmentScreenState createState() => _UserAppointmentScreenState();
}

class _UserAppointmentScreenState extends State<UserAppointmentScreen> {
  late final String doctorId;
  final AppointmentService appointmentService = AppointmentService();
  Map<String, List<String>> availableSlots = {};
  String? selectedDate;
  String? selectedSlot;

  @override
  void initState() {
    super.initState();
    doctorId = widget.doctorId; // Initialize doctorId from widget
    fetchAvailableSlots();
  }

  Future<void> fetchAvailableSlots() async {
    try {
      final slots =
          await appointmentService.getAvailableDateTimeSlots(doctorId);
      setState(() {
        availableSlots = slots;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load available slots: $error')),
      );
    }
  }

  Future<void> bookAppointment() async {
    if (selectedDate == null || selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and slot')),
      );
      return;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken().then((value) {
        // print("getToken:$value");
      });
      print(token);
      await appointmentService.sendNotification(
        doctorId: widget.doctorId,
        title: 'Appointment is booked',
        body: 'Please reach on time',
        fcmToken: token ?? '',
      );
      // await appointmentService.removeDateTimeSlot(
      //     doctorId, DateTime.parse(selectedDate!), selectedSlot!);

      // setState(() {
      //   availableSlots[selectedDate]?.remove(selectedSlot);
      //   selectedSlot = null; // Reset slot after booking
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment: $error')),
      );
    }
  }

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('EEE, d MMM yyyy');
      return formatter.format(date);
    } catch (e) {
      print('Error formatting date: $e');
      return dateString; // Return the original string if there's an error
    }
  }

  String formatTime(String timeString) {
    try {
      final DateTime time = DateTime.parse(timeString);
      final DateFormat formatter =
          DateFormat('h:mm a'); // Format time as 12-hour clock
      return formatter.format(time);
    } catch (e) {
      print('Error formatting time: $e');
      return timeString; // Return the original string if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Appointment Slot')),
      body: Column(
        children: [
          // Date Selection
          if (availableSlots.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                hint: Text('Select Date'),
                value: selectedDate,
                onChanged: (newDate) {
                  setState(() {
                    selectedDate = newDate;
                    selectedSlot = null; // Reset slot when date changes
                  });
                },
                items: availableSlots.keys.map<DropdownMenuItem<String>>(
                  (date) {
                    return DropdownMenuItem<String>(
                      value: date,
                      child: Text(formatDate(date)),
                    );
                  },
                ).toList(),
              ),
            ),
          // Time slots
          if (selectedDate != null) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    physics:
                        NeverScrollableScrollPhysics(), // Disable inner scrolling
                    shrinkWrap: true, // Wrap content size
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: availableSlots[selectedDate]!.length,
                    itemBuilder: (context, index) {
                      final slot = availableSlots[selectedDate]![index];
                      final isSelected = slot == selectedSlot;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSlot = slot;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.blueAccent : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected ? Colors.blueAccent : Colors.grey,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatTime(slot),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatDate(
                                    slot), // Display the date for each slot
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          // Book Appointment Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bookAppointment,
                child: Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
