class Patient {
  final String id;
  final String name;
  final int heartRate;
  final int steps;
  final double distance;

  Patient({
    required this.id,
    required this.name,
    required this.heartRate,
    required this.steps,
    required this.distance,
  });

  @override
  String toString() {
    return 'Patient(id: $id, name: $name, heartRate: $heartRate, steps: $steps, distance: $distance)';
  }
}
