import 'dart:convert';

import 'package:swasth_bharat/common/widgets/bottom_bar.dart';
import 'package:swasth_bharat/constants/error_handling.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/constants/utils.dart';
import 'package:swasth_bharat/features/admin/screens/admin_screen.dart';
import 'package:swasth_bharat/models/doctor.dart';
import 'package:swasth_bharat/providers/doctor_provider.dart';
import 'package:swasth_bharat/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceDoctor {
  // sign up user
  void signUpDoctor({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String specialty,
    required String description,
    required String location,
    required String clinicName,
    required int workExperience,
    required int numberofPatientsViewed,
    required int rating,
    required int reviewCount,
  }) async {
    try {
      Doctor doctor = Doctor(
        id: '',
        name: name,
        specialty: specialty,
        email: email,
        description: description,
        workExperience: workExperience,
        rating: rating,
        reviewCount: reviewCount,
        location: location,
        password: password,
        token: '',
        clinicName: clinicName,
        numberofPatientsViewed: numberofPatientsViewed,
        availableDateTimeSlots: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/doctorAuth/signup'),
        body: doctor.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Doctor Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  void signInDoctor({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/doctorAuth/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<DoctorProvider>(context, listen: false)
              .setDoctor(res.body);

          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AdminScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getDoctorData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/doctorAuth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response doctorRes = await http.get(
          Uri.parse('$uri/doctorAuth/getDoctor'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var doctorProvider =
            Provider.of<DoctorProvider>(context, listen: false);
        doctorProvider.setDoctor(doctorRes.body);
        print('Doctor response body: ${doctorRes.body}');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
