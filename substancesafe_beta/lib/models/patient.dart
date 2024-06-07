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
}
