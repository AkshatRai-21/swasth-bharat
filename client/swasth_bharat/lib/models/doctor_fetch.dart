import 'package:flutter/material.dart';

// Define the Location class
class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: List<double>.from(json['coordinates'] ?? []),
    );
  }
}

class Doctor {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final String image;
  final String description;
  final int workExperience;
  final String clinicName;
  final int numberOfPatientsViewed;
  final int experience;
  final double rating;
  final int reviewCount;
  final List<String> availableDateTimeSlots;
  final Location? location; // Add Location here
  final String password; // Add password here
  final String token; // Add token here
  final String distance;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.image,
    required this.description,
    required this.workExperience,
    required this.clinicName,
    required this.numberOfPatientsViewed,
    required this.experience,
    required this.rating,
    required this.reviewCount,
    required this.availableDateTimeSlots,
    this.location, // Initialize location here
    required this.password,
    required this.token,
    required this.distance,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      specialty: json['specialty'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      workExperience: json['workExperience'] ?? 0,
      clinicName: json['clinicName'] ?? '',
      numberOfPatientsViewed: json['numberOfPatientsViewed'] ?? 0,
      experience: json['experience'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      availableDateTimeSlots:
          List<String>.from(json['availableDateTimeSlots'] ?? []),
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      password: json['password'] ?? '',
      token: json['token'] ?? '',
      distance: json['distance'] ?? "0",
    );
  }
}
