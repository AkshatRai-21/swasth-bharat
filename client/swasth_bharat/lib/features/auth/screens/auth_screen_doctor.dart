import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as location;
import 'package:swasth_bharat/common/widgets/custom_button.dart';
import 'package:swasth_bharat/common/widgets/custom_textfield.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/features/auth/services/auth_service_doctor.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreenDoctor extends StatefulWidget {
  const AuthScreenDoctor({super.key});
  static const String routeName = '/admin-screen';

  @override
  State<AuthScreenDoctor> createState() => _AuthScreenDoctorState();
}

class _AuthScreenDoctorState extends State<AuthScreenDoctor> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthServiceDoctor authServiceDoctor = AuthServiceDoctor();

  // TextEditingControllers for the user model
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // TextEditingControllers for the doctor model
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _workExperienceController =
      TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _reviewCountController = TextEditingController();
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _numberOfPatientsViewed = TextEditingController();

  // Location controller
  final location.Location _location = location.Location();
  String _fullLocationData =
      ""; // Store full location data (address + coordinates)
  String _displayedLocation = "Fetching location..."; // Displayed location text

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  // Fetch and set user's current location
  void _fetchUserLocation() async {
    try {
      final locationData = await _location.getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      if (latitude != null && longitude != null) {
        List<geocoding.Placemark> placemarks =
            await geocoding.placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          geocoding.Placemark place = placemarks[0];
          String address =
              "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";

          setState(() {
            _displayedLocation = address; // Update displayed location
            _fullLocationData = "$latitude,$longitude"; // Full data for backend
          });
        }
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void signUpUser() async {
    authServiceDoctor.signUpDoctor(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      specialty: _specialtyController.text,
      description: _descriptionController.text,
      location: _fullLocationData, // Pass full location data to backend
      clinicName: _clinicNameController.text,
      workExperience: int.tryParse(_workExperienceController.text) ?? 0,
      numberofPatientsViewed: int.tryParse(_numberOfPatientsViewed.text) ?? 0,
      rating: int.tryParse(_ratingController.text) ?? 0,
      reviewCount: int.tryParse(_reviewCountController.text) ?? 0,
    );
  }

  void signInUser() {
    authServiceDoctor.signInDoctor(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ListTile(
                  tileColor: _auth == Auth.signup
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signup,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                  ),
                ),
                if (_auth == Auth.signup)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Name',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _specialtyController,
                            hintText: 'Specialty',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _descriptionController,
                            hintText: 'Description',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _workExperienceController,
                            hintText: 'Work Experience (years)',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _numberOfPatientsViewed,
                            hintText: 'Number Of Patients Viewed',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _ratingController,
                            hintText: 'Rating',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _reviewCountController,
                            hintText: 'Review Count',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _clinicNameController,
                            hintText: 'Clinic Name',
                          ),
                          const SizedBox(height: 10),
                          // Displaying the location in a ListTile with a marker
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title: const Text(
                              'Current Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _displayedLocation,
                              style: TextStyle(
                                color:
                                    _displayedLocation == "Fetching location..."
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                            ),
                            onTap:
                                _fetchUserLocation, // Re-fetch location on tap
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            text: 'Sign Up',
                            onTap: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                signUpUser();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: _auth == Auth.signin
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: const Text(
                    'Sign-In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signin,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                  ),
                ),
                if (_auth == Auth.signin)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            text: 'Sign In',
                            onTap: () {
                              if (_signInFormKey.currentState!.validate()) {
                                signInUser();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
