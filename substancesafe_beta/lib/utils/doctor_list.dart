import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/doctor.dart';

List<Doctor> doctor_list = List.empty(growable: true);

void add(Doctor doctor) {
  doctor_list.add(doctor);
  _storeCredentials();
  print(usersToString(doctor_list));
}
String usersToString(List<Doctor> users) {
  return users.map((user) => user.toString()).join(', ');
}

void removeDoctor(Doctor doctor) {
  _removeCredentials();
  doctor_list.remove(doctor);
  _storeCredentials();
}

List<String> getNames(List<Doctor> doctor) {
  return doctor.map((doctor) => doctor.name).toList();
}

List<String> getPasswords(List<Doctor> doctor) {
  return doctor.map((doctor) => doctor.password).toList();
}

@override
List<String> getEmails(List<Doctor> doctor) {
  return doctor.map((doctor) => doctor.email).toList();
}
Future<void> _storeCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Encode and store data in SharedPreferences
  final String encodedDoctorData = Doctor.encode(doctor_list);

  await prefs.setString('doctor_key', encodedDoctorData);
  }

  Future<void> _removeCredentials() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('doctor_key');
  }
  Future<List<Doctor>> getDoctors() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Fetch and decode data
  final String? doctorString = await prefs.getString('doctor_key');
  if(doctorString==null){
    return doctor_list;
  }else{
     return Doctor.decode(doctorString);
  }
 
}