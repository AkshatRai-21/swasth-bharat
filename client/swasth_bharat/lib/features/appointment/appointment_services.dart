import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:swasth_bharat/constants/global_variables.dart';

class AppointmentService {
  Future<void> saveDateTimeSlots(
      String doctorId, String date, List<String> slots) async {
    // Construct the URL with the doctorId
    final url = Uri.parse('$uri/api/doctors/$doctorId/saveDateTimeSlots');

    // Make the POST request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'date': date, 'slots': slots}),
    );

    // Handle response
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'];
      throw Exception('Error: $error');
    }
  }

  // New method to fetch available dates and time slots
  Future<Map<String, List<String>>> getAvailableDateTimeSlots(
      String doctorId) async {
    final url =
        Uri.parse('$uri/api/doctors/${doctorId}/availableDateTimeSlots');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data
          .map((date, slots) => MapEntry(date, List<String>.from(slots)));
    } else {
      throw Exception('Failed to load available slots');
    }
  }

  Future<void> removeDateTimeSlot(
      String doctorId, DateTime date, String slot) async {
    // Format the date as 'YYYY-MM-DD'
    final formattedDate = date.toIso8601String().split('T')[0];

    // Construct the URL with the formatted date and slot
    final url = Uri.parse('$uri/api/doctors/${doctorId}/removeDateTimeSlot');

    // Make the DELETE request
    final response = await http.delete(url);

    // Check if the response status is not 200 (OK)
    if (response.statusCode != 200) {
      // Decode the response body and extract the error message
      final error = jsonDecode(response.body)['error'];
      // Throw an exception with the error message
      throw Exception('Error: $error');
    }
  }

  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    String doctorId = '',
    int delayInMinutes = 0,
  }) async {
    final Map<String, dynamic> payload = {
      'fcmToken': fcmToken,
      'title': title,
      'body': body,
      'doctorId': doctorId,
      'delayInMinutes': delayInMinutes.toString(),
    };
    final String _apiUrl = '$uri/user/notifications/schedule';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // Successful API call
        print("resonse yeh haiu $response");
        print('Notification sent successfully');
      } else {
        // Handle error response
        print('Failed to send notification: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
