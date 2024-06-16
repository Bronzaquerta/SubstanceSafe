// patient_list.dart
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/patient.dart';

final List<Map<String, String>> patients = [
  {'name': 'Oguzhan Telli', 'number': '1', 'id': '123'},
  {'name': 'Thomas Jahreis', 'number': '2', 'id': '321'},
  {'name': 'Linda Jalonen', 'number': '3', 'id': '213'},
  {'name': 'Giacomo Cappon', 'number': '4', 'id': '231'},
  // Add more patients here
];

class PatientList {
  List<Patient> patient_list = List.empty(growable: true);
  PatientList(List<Patient> patients) {
    patient_list = patients;
  }

  void add(Patient patient) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    patient_list.add(patient);
    savePatients(patient_list);
  }

  void removePatient(Patient patient) {
    _removeCredentials();
    patient_list.remove(patient);
    savePatients(patient_list);
  }

  Future<List<String>> getNames() async {
    List<Patient> patients = await getPatients();
    return patients.map((patient) => patient.name).toList();
  }

  Future<List<String>> getPasswords() async {
    List<Patient> patients = await getPatients();
    return patients.map((patient) => patient.password).toList();
  }

  Future<List<String>> getEmails() async {
    List<Patient> patients = await getPatients();
    return patients.map((patient) => patient.email).toList();
  }

  Future<void> _removeCredentials() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_keyPatients);
  }

  static const String _keyPatients = 'patients';

  Future<void> savePatients(List<Patient> patients) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> patientsJson =
        patients.map((patient) => jsonEncode(patient.toJson())).toList();
    await prefs.setStringList(_keyPatients, patientsJson);
  }

  Future<List<Patient>> getPatients() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? patientsJson = prefs.getStringList(_keyPatients);
    if (patientsJson != null) {
      return patientsJson
          .map((patientString) => Patient.fromJson(jsonDecode(patientString)))
          .toList();
    } else {
      return [];
    }
  }
}
