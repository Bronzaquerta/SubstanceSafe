//PatientList.dart
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/patient.dart';

final List<Map<String, String>> patients = [
  {'name': 'Oguzhan Telli', 'number': '1', 'id': '123'},
  {'name': 'Thomas Jahreis', 'number': '2', 'id': '321'},
  {'name': 'Linda Jalonen', 'number': '3', 'id': '213'},
  {'name': 'Giacomo Cappon', 'number': '4', 'id': '231'},
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

  void removePatient(Patient patient) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    patient_list.remove(patient);
    savePatients(patient_list);
  }

  void updatedDatas(int patient_number, bool? hasDrank, bool? doesSport,
      bool? isSmoker, String notes) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    Patient modifiedPatient = patient_list[patient_number].copyWith(
        hasDrank: hasDrank ?? patient_list[patient_number].hasDrank,
        doesSport: doesSport ?? patient_list[patient_number].doesSport,
        isSmoker: isSmoker ?? patient_list[patient_number].isSmoker,
        notes: notes);
    int index =
        patient_list.indexWhere((obj) => obj.email == modifiedPatient.email);
    patient_list[index] = modifiedPatient;
    savePatients(patient_list);
  }

  Future<List<bool>> retriveDatas(int patient_number) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    List<bool> datas = [];
    datas.add(patient_list[patient_number].hasDrank);
    datas.add(patient_list[patient_number].doesSport);
    datas.add(patient_list[patient_number].isSmoker);
    return datas;
  }

  void updateNotes(int patient_number, String notes) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    Patient modifiedPatient =
        patient_list[patient_number].copyWith(notes: notes);
    int index =
        patient_list.indexWhere((obj) => obj.email == modifiedPatient.email);
    patient_list[index] = modifiedPatient;
    savePatients(patient_list);
  }

  Future<String> getNotes(int patient_number) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    String notes = patient_list[patient_number].notes;
    return notes;
  }

  void cancelNotes(int patient_number) async {
    PatientList oldPatients = PatientList([]);
    patient_list = await oldPatients.getPatients();
    patient_list[patient_number].cancelNotes();
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

  static const String _keyPatients = 'patients';
  static bool _isSaving = false;
  Future<void> savePatients(List<Patient> patients) async {
    if (_isSaving) return; // Prevent re-entrance
    _isSaving = true;
    try {
      var prefs = await SharedPreferences.getInstance();

      List<String> patientsJson =
          patients.map((patient) => jsonEncode(patient.toJson())).toList();

      await prefs.setStringList(_keyPatients, patientsJson);
    } finally {
      _isSaving = false;
    }
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
