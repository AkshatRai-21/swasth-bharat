class Appointment {
  final String id;
  final String doctorName;
  final String date;
  final String time;
  final String patientName;
  final String patientPhone;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.patientName,
    required this.patientPhone,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? '', // Add default values to handle null
      doctorName: json['doctorId']?['name'] ?? 'Unknown',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      patientName: json['patientDetails']?['name'] ?? 'Unknown',
      patientPhone: json['patientDetails']?['phone'] ?? '',
    );
  }
}
