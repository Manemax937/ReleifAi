class Incident {
  const Incident({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.priority,
    required this.reportedAt,
    required this.description,
    this.assignedTeam,
    this.incidentType,
    this.reporterName,
    this.reporterEmail,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String title;
  final String location;
  final String status;
  final String priority;
  final DateTime reportedAt;
  final String description;
  final String? assignedTeam;
  final String? incidentType;
  final String? reporterName;
  final String? reporterEmail;
  final double? latitude;
  final double? longitude;
}
