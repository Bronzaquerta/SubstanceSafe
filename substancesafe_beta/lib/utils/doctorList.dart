//doctorList.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/doctor.dart';

class DoctorList {
  List<Doctor> doctor_list = List.empty(growable: true);
  DoctorList(List<Doctor> doctors) {
    doctor_list = doctors;
  }
  void add(Doctor doctor) async {
    DoctorList oldDoctors = DoctorList([]);
    doctor_list = await oldDoctors.getDoctors();
    doctor_list.add(doctor);
    saveDoctors(doctor_list);
  }

  void removeDoctor(Doctor doctor) async {
    _removeCredentials();
    DoctorList oldDoctors = DoctorList([]);
    doctor_list = await oldDoctors.getDoctors();
    doctor_list.remove(doctor);
    saveDoctors(doctor_list);
  }

  Future<List<String>> getNames() async {
    List<Doctor> doctors = await getDoctors();
    return doctors.map((doctor) => doctor.name).toList();
  }

  Future<List<String>> getPasswords() async {
    List<Doctor> doctors = await getDoctors();
    return doctors.map((doctor) => doctor.password).toList();
  }

  Future<List<String>> getEmails() async {
    List<Doctor> doctors = await getDoctors();
    return doctors.map((doctor) => doctor.email).toList();
  }

  Future<void> _removeCredentials() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_keyDoctors);
  }

  static const String _keyDoctors = 'doctors';

  Future<void> saveDoctors(List<Doctor> doctors) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> doctorsJson =
        doctors.map((doctor) => jsonEncode(doctor.toJson())).toList();
    await prefs.setStringList(_keyDoctors, doctorsJson);
  }

  Future<List<Doctor>> getDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? doctorsJson = prefs.getStringList(_keyDoctors);
    if (doctorsJson != null) {
      return doctorsJson
          .map((doctorString) => Doctor.fromJson(jsonDecode(doctorString)))
          .toList();
    } else {
      return [];
    }
  }
}
