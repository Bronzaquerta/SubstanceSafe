//impact.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/data_model.dart';

import 'package:intl/intl.dart';


class Impact {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';
  static String stepsEndpoint = 'data/v1/steps/patients/';
  static String heartRateEndpoint = 'data/v1/heart_rate/patients/';
  static String distanceEndpoint = 'data/v1/distance/patients/';

  static String username = 'lYQeeHqPeV';
  static String password = '12345678!';

  static Future<int?> authorize() async {
    final url = baseUrl + tokenEndpoint;
    final body = {'username': username, 'password': password};

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    return response.statusCode;
  }

  static Future<List<DataModel>> fetchStepsData(String patientNumber,
      {DateTime? date}) async {
    return fetchData(patientNumber, stepsEndpoint, date);
  }

  static Future<List<DataModel>> fetchHeartRateData(String patientNumber,
      {DateTime? date}) async {
    return fetchData(patientNumber, heartRateEndpoint, date);
  }

  static Future<List<DataModel>> fetchDistanceData(String patientNumber,
      {DateTime? date}) async {
    return fetchData(patientNumber, distanceEndpoint, date);
  }

  static Future<List<DataModel>> fetchData(
      String patientNumber, String endpoint, DateTime? date) async {
    List<DataModel> result = [];

    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    if (access == null || JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }

    final formattedDate =
        date != null ? DateFormat('yyyy-MM-dd').format(date) : '2024-05-04';
    final url = '$baseUrl$endpoint$patientNumber/day/$formattedDate/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    final response = await http.get(Uri.parse(url), headers: headers);

    //print('Fetching data from: $url');
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse['data'] != null &&
          decodedResponse['data']['data'] != null) {
        for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
          result.add(DataModel.fromJson(decodedResponse['data']['date'],
              decodedResponse['data']['data'][i]));
        }
      }
    } else {
      print('Error fetching data: ${response.body}');
    }

    return result;
  }

  static Future<int> _refreshTokens() async {
    final url = baseUrl + refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    }

    return response.statusCode;
  }
}