//doctor.dart
class Doctor {
  String email;
  String name;
  String password;

  Doctor({required this.email, required this.name, required this.password});

  @override
  String toString() {
    return 'Doctor(email: $email, name: $name, password: $password)';
  }

  bool checkPassword(String inputPassword) {
    return inputPassword == password;
  }

  void updateDoctorInfo(String newName, String newPassword) {
    name = newName;
    password = newPassword;
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      email: json['email'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
