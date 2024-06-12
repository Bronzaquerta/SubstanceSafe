// patient_list.dart
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/patient.dart';


final List<Map<String, String>> patients = [
  {'name': 'Oguzhan Telli', 'number': '1', 'id': '123'},
  {'name': 'Thomas Jahreis', 'number': '2', 'id': '321'},
  {'name': 'Linda Jalonen', 'number': '3', 'id': '213'},
  {'name': 'Giacomo Cappon', 'number': '4', 'id': '231'},
  // Add more patients here
];
List<Patient> patient_list = List.empty(growable: true);

void add(Patient patient) {
  patient_list.add(patient);
  _storeCredentials();
}

void removePatient(Patient patient) {
  _removeCredentials();
  patient_list.remove(patient);
  _storeCredentials();
}

List<String> getNames(List<Patient> patient) {
  return patient.map((patient) => patient.name).toList();
}

List<String> getPasswords(List<Patient> patient) {
  return patient.map((patient) => patient.password).toList();
}

@override
List<String> getEmails(List<Patient> patient) {
  return patient.map((patient) => patient.email).toList();
}
Future<void> _storeCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Encode and store data in SharedPreferences
  final String encodedPatientData = Patient.encode(patient_list);

  await prefs.setString('patient_key', encodedPatientData);
  }

  Future<void> _removeCredentials() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('patient_key');
  }
  Future<List<Patient>> getPatients() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Fetch and decode data
  final String? patientString = await prefs.getString('patient_key');
  if(patientString==null){
    return patient_list;
  }else{
     return Patient.decode(patientString);
  }
 
}