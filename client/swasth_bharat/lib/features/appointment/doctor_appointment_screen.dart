import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swasth_bharat/features/appointment/appointment_services.dart';
import '/constants/time_slot.dart';
import 'package:swasth_bharat/constants/utils.dart';
import 'package:swasth_bharat/providers/doctor_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  @override
  _DoctorAppointmentScreenState createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  DateTime? selectedDate;
  List<String> selectedSlots = [];
  final AppointmentService appointmentService =
      AppointmentService(); // Provide baseUrl

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctorId = doctorProvider.doctor.id;

    Future<void> saveDateTimeSlots() async {
      if (selectedDate == null || selectedSlots.isEmpty) {
        showSnackBar(
            context, 'Please select a date and at least one time slot.');
        return;
      }

      final dateString =
          "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";

      try {
        await appointmentService.saveDateTimeSlots(
            doctorId, dateString, selectedSlots);
        showSnackBar(context, 'Date and time slots saved successfully.');
      } catch (error) {
        showSnackBar(context, error.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Select Available Slots')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Minimize the height of the Column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: selectedDate ?? DateTime.now(),
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      selectedSlots =
                          []; // Clear the selected slots when the date changes
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                ),
                SizedBox(height: 20),
                Text('Select Time Slots:'),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: availableSlots.map((slot) {
                    final isSelected = selectedSlots.contains(slot);
                    return ChoiceChip(
                      label: Text(slot),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedSlots.add(slot);
                          } else {
                            selectedSlots.remove(slot);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity, // Set width to double.infinity
                  child: ElevatedButton(
                    onPressed: saveDateTimeSlots,
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
