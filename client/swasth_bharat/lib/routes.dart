import 'package:flutter/material.dart';
import 'package:swasth_bharat/common/widgets/bottom_bar.dart';
import 'package:swasth_bharat/features/address/screens/address_screen.dart';
import 'package:swasth_bharat/features/admin/screens/add_product_screen.dart';
import 'package:swasth_bharat/features/admin/screens/admin_screen.dart';
import 'package:swasth_bharat/features/appointment/user_appointment_screen.dart';
import 'package:swasth_bharat/features/auth/screens/auth_screen.dart';
import 'package:swasth_bharat/features/home/screens/category_deals_screen.dart';
import 'package:swasth_bharat/features/home/screens/home_screen.dart';
import 'package:swasth_bharat/features/order_details/screens/order_details.dart';
import 'package:swasth_bharat/features/notifications/screens/notification_screen.dart';
import 'package:swasth_bharat/features/product_details/screens/product_details_screen.dart';
import 'package:swasth_bharat/features/search/screens/search_screen.dart';
import 'package:swasth_bharat/models/doctor_fetch.dart';
import 'package:swasth_bharat/models/order.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case DoctorDetailScreen.routeName:
      var doctor = routeSettings.arguments as Doctor;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => DoctorDetailScreen(
          doctor: doctor,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case NotificationScreen.routeName: // Add this route
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NotificationScreen(),
      );

    case UserAppointmentScreen.routeName:
      var doctorId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UserAppointmentScreen(
          doctorId: doctorId,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
