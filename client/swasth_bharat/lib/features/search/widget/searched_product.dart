import 'package:flutter/material.dart';
import 'package:swasth_bharat/models/doctor_fetch.dart';
import 'package:swasth_bharat/common/widgets/stars.dart'; // Adjust this import if needed

class SearchedDoctor extends StatelessWidget {
  final Doctor doctor;

  const SearchedDoctor({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Image.network(
              //   doctor.image,
              //   fit: BoxFit.contain,
              //   height: 135,
              //   width: 135,
              // ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5),
                    Stars(
                      rating: doctor.rating as double,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${doctor.workExperience} years experience',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
