import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:swasth_bharat/common/widgets/custom_button.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/features/appointment/user_appointment_screen.dart';
import 'package:swasth_bharat/features/search/screens/search_screen.dart';
import 'package:swasth_bharat/providers/user_provider.dart';
import 'package:swasth_bharat/models/doctor_fetch.dart';
import 'package:swasth_bharat/common/widgets/stars.dart';

class DoctorDetailScreen extends StatefulWidget {
  static const String routeName = '/doctor-details';
  final Doctor doctor;

  DoctorDetailScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);
  final images = [
    'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1661764878654-3d0fc2eefcca?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1661766718556-13c2efac1388?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://unsplash.com/photos/senior-male-doctor-working-on-laptop-at-the-office-desk-akPctn2G0jM',
    'https://media.istockphoto.com/id/524539495/photo/indian-doctor.webp?b=1&s=170667a&w=0&k=20&c=fkjRZoLnlFLA7W_MoTRxbAzt80IhScp3n0Bt5jd1nxQ=',
    'https://media.istockphoto.com/id/1742056462/photo/happy-doctor-pointing-with-finger-on-white-background-stock-photo.webp?b=1&s=170667a&w=0&k=20&c=v289rEv1EzkBvR0A1Bir78siKDlpruHdJDaH4FYtzWc=',
  ];
  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  double avgRating = 0;
  bool isFavorite = false; // Track favorite status

  void navigatetobookAppointment(String doctorId) {
    Navigator.pushNamed(context, UserAppointmentScreen.routeName,
        arguments: doctorId);
  }

  @override
  void initState() {
    super.initState();
    double totalRating =
        widget.doctor.rating; // Adjust based on your data structure
    avgRating = totalRating / 1.2; // Adjust based on your data structure

    // Check if doctor is already a favorite
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id; // Get user ID from provider

    final response =
        await http.get(Uri.parse('$uri/favourites/favorites/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final favorites = List<Map<String, dynamic>>.from(data['favorites']);

      // Check if the current doctor is in the favorites list
      setState(() {
        isFavorite =
            favorites.any((doctor) => doctor['_id'] == widget.doctor.id);
      });
    } else {
      // Handle errors
      print('Failed to load favorites');
    }
  }

  Future<void> _toggleFavorite() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id; // Get user ID from provider
    final doctorId = widget.doctor.id; // Get doctor ID from widget

    final url = isFavorite
        ? '$uri/favourites/remove-favorite'
        : '$uri/favourites/add-favorite';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'doctorId': doctorId,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      print('Failed to toggle favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    elevation: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search doctors...',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      onFieldSubmitted: (query) {
                        Navigator.pushNamed(
                          context,
                          SearchScreen.routeName,
                          arguments: query,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor's image
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                      widget.images[0]), // Placeholder image if none provided
                ),
              ),
            ),

            // Doctor's name, rating, and favorite icon
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Favorite icon
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _toggleFavorite();
                    },
                  ),
                  Stars(
                    rating: avgRating,
                  ),
                ],
              ),
            ),

            // Doctor's specialty
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                widget.doctor.specialty,
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            // Divider
            const Divider(height: 5, color: Colors.black12),

            // Doctor's description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.doctor.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.doctor.email ?? 'Not available'),
                  const SizedBox(height: 10),
                  Text(
                    'Clinic Location:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.doctor.clinicName ?? 'Not available'),
                ],
              ),
            ),

            // Divider
            const Divider(height: 5, color: Colors.black12),

            // Book an appointment button
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: 'Book An Appointment',
                onTap: () {
                  navigatetobookAppointment(widget.doctor.id);
                },
                color: const Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
