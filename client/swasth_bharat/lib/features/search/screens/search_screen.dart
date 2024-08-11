import 'package:flutter/material.dart';
import 'package:swasth_bharat/common/widgets/loader.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/features/search/services/search_services.dart';
import 'package:swasth_bharat/features/search/widget/searched_product.dart';
import 'package:swasth_bharat/features/product_details/screens/product_details_screen.dart'; // Update this import to use a doctor widget
import 'package:swasth_bharat/models/doctor_fetch.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;

  const SearchScreen({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Doctor>? doctors;
  final SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    fetchSearchedDoctors();
  }

  final List<String> images = [
    'https://media.istockphoto.com/id/1742056462/photo/happy-doctor-pointing-with-finger-on-white-background-stock-photo.webp?b=1&s=170667a&w=0&k=20&c=v289rEv1EzkBvR0A1Bir78siKDlpruHdJDaH4FYtzWc=',
    'https://plus.unsplash.com/premium_photo-1661766718556-13c2efac1388?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1661764878654-3d0fc2eefcca?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZG9jdG9yfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://unsplash.com/photos/senior-male-doctor-working-on-laptop-at-the-office-desk-akPctn2G0jM',
    'https://media.istockphoto.com/id/524539495/photo/indian-doctor.webp?b=1&s=170667a&w=0&k=20&c=fkjRZoLnlFLA7W_MoTRxbAzt80IhScp3n0Bt5jd1nxQ=',
  ];

  fetchSearchedDoctors() async {
    doctors = await searchServices.fetchSearchedDoctors(
      context: context,
      searchQuery: widget.searchQuery,
    );
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
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
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
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
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.notifications,
                    color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: doctors == null
          ? const Loader()
          : Stack(
              children: [
                // Background Images
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(images[index]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    controller: PageController(viewportFraction: 1),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: doctors!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  DoctorDetailScreen.routeName,
                                  arguments: doctors![index],
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: SearchedDoctor(
                                  doctor: doctors![index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
