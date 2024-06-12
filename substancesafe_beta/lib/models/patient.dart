import 'dart:convert';

class Patient {
  final String email;
  final String name;
  final String password;
  late int heartRate;
  late int steps;
  late double distance;

  Patient({
    required this.email,
    required this.name,
    required this.password
  });

  addHeartrate(heartRate){
    this.heartRate=heartRate;
  }
  addSteps(steps){
    this.steps=steps;
  }
  addDistance(distance){
    this.distance=distance;
  }
  @override
  String toString() {
    return 'Patient(id: $email, name: $name, heartRate: $heartRate, steps: $steps, distance: $distance)';
  }
  factory Patient.fromJson(Map<String, dynamic> jsonData) {
    return Patient(
      email: jsonData['email'],
      name: jsonData['name'],
      password: jsonData['password'],
    );
  }
  static Map<String, dynamic> toMap(Patient patient) => {
        'email': patient.email,
        'name': patient.name,
        'password': patient.password,
      };
  static String encode(List<Patient> patient) => json.encode(
        patient
            .map<Map<String, dynamic>>((patient) => Patient.toMap(patient))
            .toList(),
      );

  static List<Patient> decode(String patient) =>
      (json.decode(patient) as List<dynamic>)
          .map<Patient>((item) => Patient.fromJson(item))
          .toList();
}

