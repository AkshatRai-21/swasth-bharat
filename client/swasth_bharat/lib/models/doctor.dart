import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String email;
  final String? image;
  final String description;
  final int workExperience;
  final int rating;
  final int reviewCount;
  final String? location;
  final String password;
  final String token;
  final String clinicName;
  final int numberofPatientsViewed;

  final List<dynamic>? availableDateTimeSlots;
  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
    this.image,
    required this.description,
    required this.workExperience,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.password,
    required this.token,
    required this.clinicName,
    required this.numberofPatientsViewed,
    this.availableDateTimeSlots,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'specialty': specialty,
      'email': email,
      'image': image,
      'description': description,
      'workExperience': workExperience,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'password': password,
      'token': token,
      'clinicName': clinicName,
      'numberofPatientsViewed': numberofPatientsViewed,
      'availableDateTimeSlots': availableDateTimeSlots,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['_id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      email: map['email'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      description: map['description'] as String,
      workExperience: map['workExperience'] as int,
      rating: map['rating'] as int,
      reviewCount: map['reviewCount'] as int,
      location: map['location'] != null ? map['location'] as String : null,
      password: map['password'] as String,
      token: map['token'] as String,
      clinicName: map['clinicName'] as String,
      numberofPatientsViewed: map['numberofPatientsViewed'] as int,
      availableDateTimeSlots: map['availableDateTimeSlots'] != null
          ? List<dynamic>.from((map['availableDateTimeSlots'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) =>
      Doctor.fromMap(json.decode(source) as Map<String, dynamic>);
}
