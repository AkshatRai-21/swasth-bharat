import 'dart:convert';

import 'package:swasth_bharat/constants/error_handling.dart';
import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/constants/utils.dart';
import 'package:swasth_bharat/models/doctor_fetch.dart';
import 'package:swasth_bharat/models/product.dart';
import 'package:swasth_bharat/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchServices {
  Future<List<Doctor>> fetchSearchedDoctors({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Doctor> doctorList = [];
    try {
      http.Response res = await http.get(
        Uri.parse(
            '$uri/api/doctors/search-doctor?name=$searchQuery'), // Update the endpoint for doctors
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            doctorList.add(
              Doctor.fromJson(
                jsonDecode(res.body)[i],
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return doctorList;
  }

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}
