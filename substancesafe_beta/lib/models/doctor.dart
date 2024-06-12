import 'dart:convert';

class Doctor {
  String email;
  String name;
  String password;
  
  Doctor({required this.email, required this.name, required this.password});
  
   @override
  String toString() {
    return 'User(email: $email, name: $name, password: $password)';
  }
  
  // checking the password 
  bool checkPassword(String inputPassword) {
    return inputPassword == password;
  }
  
  // updating the doctor information
  void updateDoctorInfo(String newName, String newPassword) {
    name = newName;
    password = newPassword;
  }

  factory Doctor.fromJson(Map<String, dynamic> jsonData) {
    return Doctor(
      email: jsonData['email'],
      name: jsonData['name'],
      password: jsonData['password'],
    );
  }
  static Map<String, dynamic> toMap(Doctor doctor) => {
        'email': doctor.email,
        'name': doctor.name,
        'password': doctor.password,
      };
  static String encode(List<Doctor> doctor) => json.encode(
        doctor
            .map<Map<String, dynamic>>((doctor) => Doctor.toMap(doctor))
            .toList(),
      );

  static List<Doctor> decode(String doctor) =>
      (json.decode(doctor) as List<dynamic>)
          .map<Doctor>((item) => Doctor.fromJson(item))
          .toList();
}

