import 'package:flutter/material.dart';
import 'package:swasth_bharat/models/doctor.dart';

class DoctorProvider extends ChangeNotifier {
  Doctor _doctor = Doctor(
      id: '',
      name: '',
      email: '',
      password: '',
      image: '',
      token: '',
      specialty: '',
      description: '',
      workExperience: 0,
      location: '',
      clinicName: '',
      numberofPatientsViewed: 0,
      rating: 0,
      reviewCount: 0,
      availableDateTimeSlots: []);

  Doctor get doctor => _doctor;

  void setDoctor(String doctor) {
    _doctor = Doctor.fromJson(doctor);
    notifyListeners();
  }

  void setDoctorFromModel(Doctor doctor) {
    _doctor = doctor;
    notifyListeners();
  }
}
