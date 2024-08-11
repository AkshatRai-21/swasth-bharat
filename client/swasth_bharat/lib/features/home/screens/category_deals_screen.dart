import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/features/home/services/home_services.dart';
import 'package:swasth_bharat/features/product_details/screens/product_details_screen.dart';
import 'package:swasth_bharat/models/doctor_fetch.dart';
import 'package:swasth_bharat/common/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';

  final String category;
  const CategoryDealsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Doctor>? doctorList;
  final HomeServices homeServices = HomeServices();

  final images = [
    'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1661764878654-3d0fc2eefcca?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1661766718556-13c2efac1388?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://unsplash.com/photos/senior-male-doctor-working-on-laptop-at-the-office-desk-akPctn2G0jM',
    'https://media.istockphoto.com/id/524539495/photo/indian-doctor.webp?b=1&s=170667a&w=0&k=20&c=fkjRZoLnlFLA7W_MoTRxbAzt80IhScp3n0Bt5jd1nxQ=',
    'https://media.istockphoto.com/id/1742056462/photo/happy-doctor-pointing-with-finger-on-white-background-stock-photo.webp?b=1&s=170667a&w=0&k=20&c=v289rEv1EzkBvR0A1Bir78siKDlpruHdJDaH4FYtzWc=',
  ];
  @override
  void initState() {
    super.initState();
    fetchCategoryDoctors();
  }

  fetchCategoryDoctors() async {
    doctorList = await homeServices.fetchcategoryDoctors(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: doctorList == null
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GridView.builder(
                scrollDirection: Axis.vertical, // Make it vertically scrollable
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: doctorList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  childAspectRatio: 0.75, // Aspect ratio of each item
                  mainAxisSpacing: 15, // Space between rows
                  crossAxisSpacing: 15, // Space between columns
                ),
                itemBuilder: (context, index) {
                  final doctor = doctorList![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DoctorDetailScreen.routeName,
                        arguments: doctor,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            images[index], // Use doctor's image for background
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ), // Optional: Darken the image for better text readability
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display doctor's name
                            Text(
                              doctor.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              doctor.clinicName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              doctor.email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              doctor.specialty,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  doctor.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _openGoogleMaps(
                                  doctor.location!.coordinates[1], // Latitude
                                  doctor.location!.coordinates[0], // Longitude
                                );
                              },
                              child: const Text('View on Map'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
