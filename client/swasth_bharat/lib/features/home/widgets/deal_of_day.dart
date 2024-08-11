import '/common/widgets/loader.dart';
import '/features/home/services/home_services.dart';
import '/models/doctor_fetch.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DoctorsList extends StatefulWidget {
  const DoctorsList({Key? key}) : super(key: key);

  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  List<Doctor>? doctors;
  final HomeServices homeServices = HomeServices();
  late Position _currentPosition;

  double _selectedRadius = 50.0; // Default radius value
  final List<double> _radiusOptions = [
    50.0,
    100.0,
    1000.0,
    5000.0
  ]; // Radius options in kilometers

  final images = [
    'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1661766718556-13c2efac1388?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://unsplash.com/photos/senior-male-doctor-working-on-laptop-at-the-office-desk-akPctn2G0jM',
    'https://plus.unsplash.com/premium_photo-1661764878654-3d0fc2eefcca?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://media.istockphoto.com/id/524539495/photo/indian-doctor.webp?b=1&s=170667a&w=0&k=20&c=fkjRZoLnlFLA7W_MoTRxbAzt80IhScp3n0Bt5jd1nxQ=',
    'https://media.istockphoto.com/id/1742056462/photo/happy-doctor-pointing-with-finger-on-white-background-stock-photo.webp?b=1&s=170667a&w=0&k=20&c=v289rEv1EzkBvR0A1Bir78siKDlpruHdJDaH4FYtzWc=',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check for location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        // distanceFilter: 100,
      );

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      setState(() {
        _currentPosition = position;
        fetchDoctors(); // Fetch doctors after getting the location
      });
    } catch (e) {
      // Handle any errors that occur while fetching the location
      print(e);
    }
  }

  void fetchDoctors() async {
    if (_currentPosition != null) {
      doctors = await homeServices.fetchNearDoctors(
        context: context,
        lat: _currentPosition.latitude,
        long: _currentPosition.longitude,
        radius: _selectedRadius, // Pass the selected radius
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: const Text(
            'Doctors Near You',
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Dropdown button for selecting radius
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<double>(
            value: _selectedRadius,
            items: _radiusOptions.map((radius) {
              return DropdownMenuItem<double>(
                value: radius,
                child: Text('$radius m'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedRadius = value;
                  fetchDoctors(); // Fetch doctors with new radius
                });
              }
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        doctors == null
            ? const Loader()
            : doctors!.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: 1000, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: doctors!.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors![index];
                        return Container(
                          width: 150, // Adjust width as needed
                          margin: const EdgeInsets.symmetric(
                              vertical: 5), // Adjust spacing as needed
                          padding: const EdgeInsets.all(
                              10), // Add padding inside the container
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Uncomment this section if images are available
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  images[index],
                                  height: 200,
                                  width: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                doctor.specialty,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${doctor.distance} metres',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    '${doctor.rating}⭐',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}
