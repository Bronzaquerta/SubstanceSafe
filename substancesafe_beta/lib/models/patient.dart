//patient.dart
class Patient {
  final String email;
  final String name;
  final String password;
  bool hasDrank;
  bool doesSport;
  bool isSmoker;
  String notes;

  Patient(
      {required this.email,
      required this.name,
      required this.password,
      required this.hasDrank,
      required this.doesSport,
      required this.isSmoker,
      this.notes = ''});

  Patient copyWith(
      {String? email,
      String? name,
      String? password,
      bool? hasDrank,
      bool? doesSport,
      bool? isSmoker,
      String? notes}) {
    return Patient(
        email: email ?? this.email,
        name: name ?? this.name,
        password: password ?? this.password,
        hasDrank: hasDrank ?? this.hasDrank,
        doesSport: doesSport ?? this.doesSport,
        isSmoker: isSmoker ?? this.isSmoker,
        notes: notes ?? this.notes);
  }

  void updateNotes(String newNotes) {
    notes = newNotes + '\n';
  }

  void cancelNotes() {
    notes = '';
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      email: json['email'],
      name: json['name'],
      password: json['password'],
      hasDrank: json['drinks'],
      doesSport: json['sport'],
      isSmoker: json['smoke'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'drinks': hasDrank,
      'sport': doesSport,
      'smoke': isSmoker,
      'notes': notes
    };
  }
}
