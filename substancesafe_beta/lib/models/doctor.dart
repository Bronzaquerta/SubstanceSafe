class Doctor {
  String email;
  String name;
  String password;
  
  Doctor({required this.email, required this.name, required this.password});
  
  // checking the password 
  bool checkPassword(String inputPassword) {
    return inputPassword == password;
  }
  
  // updating the doctor information
  void updateDoctorInfo(String newName, String newPassword) {
    name = newName;
    password = newPassword;
  }
}

