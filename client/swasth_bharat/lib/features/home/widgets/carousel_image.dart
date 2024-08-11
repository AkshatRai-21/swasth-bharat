import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/models/appointment_model.dart';
import 'package:http/http.dart' as http;
import 'package:swasth_bharat/providers/user_provider.dart';

class AppointmentCarousel extends StatefulWidget {
  @override
  _AppointmentCarouselState createState() => _AppointmentCarouselState();
}

Future<List<Appointment>> fetchAppointments(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final userId = userProvider.user.id;
  print(userId);

  final response = await http.get(Uri.parse('$uri/appointments/$userId'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Appointment> allAppointments =
        data.map((item) => Appointment.fromJson(item)).toList();

    // Get today's date in YYYY-MM-DD format
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Filter appointments to include only those with today's date
    final filteredAppointments = allAppointments.where((appointment) {
      // Extract YYYY-MM-DD from appointment date
      final appointmentDate = appointment.date.split('T')[0];
      return appointmentDate == today;
    }).toList();

    return filteredAppointments;
  } else {
    throw Exception('Failed to load appointments');
  }
}

class _AppointmentCarouselState extends State<AppointmentCarousel> {
  late Future<List<Appointment>> _futureAppointments;

  @override
  void initState() {
    super.initState();
    _futureAppointments = fetchAppointments(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: _futureAppointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No appointments found'));
        } else {
          List<Appointment> appointments = snapshot.data!;
          return CarouselSlider(
            items: appointments.map((appointment) {
              return Builder(
                builder: (BuildContext context) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 60, right: 60),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Today\'s Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Doctor: ${appointment.doctorName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Date: ${appointment.date}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Time: ${appointment.time}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Patient: ${appointment.patientName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Phone: ${appointment.patientPhone}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              viewportFraction: 0.9,
              height: 250,
              enableInfiniteScroll: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeInOut,
            ),
          );
        }
      },
    );
  }
}
