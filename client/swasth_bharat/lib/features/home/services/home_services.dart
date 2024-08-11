import 'dart:convert';

import 'package:swasth_bharat/models/doctor_fetch.dart';

import '/constants/error_handling.dart';
import '/constants/global_variables.dart';
import '/constants/utils.dart';
import '/models/product.dart';
import '/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

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

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
    );

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }

  // Existing methods...

  Future<List<Doctor>> fetchDoctors({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Doctor> doctorList = [];
    try {
      final response = await http.get(
        Uri.parse('$uri/api/doctors/all'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          List<dynamic> data = jsonDecode(response.body);
          doctorList = data.map((json) => Doctor.fromJson(json)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return doctorList;
  }

  Future<List<Doctor>> fetchcategoryDoctors(
      {required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Doctor> doctorList = [];
    try {
      final response = await http.get(
        Uri.parse('$uri/api/doctors/specialty?specialty=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          List<dynamic> data = jsonDecode(response.body);
          doctorList = data.map((json) => Doctor.fromJson(json)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return doctorList;
  }

  Future<List<Doctor>> fetchNearDoctors({
    required BuildContext context,
    required lat,
    required long,
    required radius,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Doctor> doctorList = [];
    try {
      final response = await http.get(
        Uri.parse(
            '$uri/api/doctors/near?latitude=$lat&longitude=$long&radius=$radius'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          List<dynamic> data = jsonDecode(response.body);
          doctorList = data.map((json) => Doctor.fromJson(json)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return doctorList;
  }
}
