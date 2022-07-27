import 'dart:convert';
import 'dart:ffi';

import 'package:blog_mobile_app/constant.dart';
import 'package:blog_mobile_app/models/apiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:blog_mobile_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = serverError;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Register
Future<ApiResponse> registerUser(
  String name,
  String email,
  String password,
) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiResponse.error = serverError;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Get Token Session
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}

// Get User Id Session
Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId') ?? 0;
}

// Logout
Future<bool> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove('token');
}
