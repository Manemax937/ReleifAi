import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../data/mock_data.dart';
import '../models/incident.dart';

class IncidentController extends ChangeNotifier {
  IncidentController() : _incidents = List<Incident>.from(MockData.incidents) {
    _authSubscription = _auth.authStateChanges().listen(_handleAuthChange);
    _handleAuthChange(_auth.currentUser);
  }

  final List<Incident> _incidents;
  List<Incident> _assignedIncidents = const [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _volunteerAssignmentsSubscription;

  List<Incident> get incidents {
    final merged = <Incident>[..._assignedIncidents, ..._incidents];
    final byId = <String, Incident>{};
    for (final incident in merged) {
      byId[incident.id] = incident;
    }
    final unique = byId.values.toList();
    unique.sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    return List.unmodifiable(unique);
  }

  List<Incident> get volunteerIncidents =>
      List.unmodifiable(_assignedIncidents);

  Incident? get latestIncident => _incidents.isEmpty ? null : _incidents.first;

  Future<void> _handleAuthChange(User? user) async {
    await _volunteerAssignmentsSubscription?.cancel();
    _volunteerAssignmentsSubscription = null;

    if (user == null) {
      _assignedIncidents = const [];
      notifyListeners();
      return;
    }

    _volunteerAssignmentsSubscription = _firestore
        .collection('dashboard_dispatches')
        .where('selectedVolunteerIds', arrayContains: user.uid)
        .snapshots()
        .listen((snapshot) async {
          await _setAssignedIncidentsFromDispatches(snapshot.docs);
        });
  }

  Future<void> _setAssignedIncidentsFromDispatches(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> dispatchDocs,
  ) async {
    final mapped = await Future.wait(
      dispatchDocs.map(_mapAssignedIncidentFromDispatch),
    );

    _assignedIncidents = mapped.whereType<Incident>().toList()
      ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    notifyListeners();
  }

  Future<void> refreshAssignedIncidents() async {
    final user = _auth.currentUser;
    if (user == null) {
      _assignedIncidents = const [];
      notifyListeners();
      return;
    }

    final snapshot = await _firestore
        .collection('dashboard_dispatches')
        .where('selectedVolunteerIds', arrayContains: user.uid)
        .get();

    await _setAssignedIncidentsFromDispatches(snapshot.docs);
  }

  Future<Incident?> _mapAssignedIncidentFromDispatch(
    QueryDocumentSnapshot<Map<String, dynamic>> dispatchDoc,
  ) async {
    final dispatchData = dispatchDoc.data();
    final incidentDocId = (dispatchData['incidentDocId'] as String?)?.trim();
    if (incidentDocId == null || incidentDocId.isEmpty) return null;

    final statusRaw = '${dispatchData['status'] ?? 'active'}'.toLowerCase();
    final status = switch (statusRaw) {
      'active' || 'dispatched' || 'in_progress' => 'In Progress',
      'resolved' => 'Resolved',
      _ => 'Open',
    };

    final incidentSnapshot = incidentDocId.startsWith('sos_')
        ? await _firestore
              .collection('sos_requests')
              .doc(incidentDocId.replaceFirst('sos_', ''))
              .get()
        : await _firestore
              .collection('dashboard_incidents')
              .doc(incidentDocId)
              .get();

    final data = incidentSnapshot.data() ?? <String, dynamic>{};

    final incidentType = (data['incidentType'] as String?)?.trim();
    final details = (data['details'] as String?)?.trim();
    final latitude = _toDouble(data['latitude']);
    final longitude = _toDouble(data['longitude']);
    final assignedVolunteerIds =
        (dispatchData['selectedVolunteerIds'] as List<dynamic>? ??
                data['assignedVolunteerIds'] as List<dynamic>? ??
                const [])
            .map((value) => value.toString())
            .toList();

    final createdAt = data['createdAt'] ?? dispatchData['createdAt'];
    final createdAtClient = data['createdAtClient'];
    final reportedAt = (createdAt is Timestamp)
        ? createdAt.toDate()
        : DateTime.tryParse((createdAtClient ?? '').toString()) ??
              DateTime.now();

    return Incident(
      id: (data['incidentId'] as String?)?.trim().isNotEmpty == true
          ? (data['incidentId'] as String).trim()
          : incidentDocId,
      title: incidentType != null && incidentType.isNotEmpty
          ? 'Assigned: $incidentType Incident'
          : 'Assigned Emergency Incident',
      location: (data['location'] as String?)?.trim().isNotEmpty == true
          ? (data['location'] as String).trim()
          : 'Unknown location',
      status: status,
      priority: '${data['severity'] ?? 'Critical'}',
      reportedAt: reportedAt,
      description: details?.isNotEmpty == true
          ? details!
          : 'Proceed to the location and coordinate with dispatch.',
      assignedTeam:
          (dispatchData['assignedTeam'] as String?) ??
          (data['dispatch'] as Map<String, dynamic>?)?['assignedTeam']
              as String?,
      incidentType: incidentType,
      reporterName:
          (data['reporter'] as Map<String, dynamic>?)?['name'] as String?,
      reporterEmail:
          (data['reporter'] as Map<String, dynamic>?)?['email'] as String?,
      latitude: latitude,
      longitude: longitude,
      guidance: _buildGuidance(
        incidentType: incidentType,
        location: (data['location'] as String?) ?? 'Unknown location',
      ),
      assignedVolunteerIds: assignedVolunteerIds,
    );
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  String _buildGuidance({
    required String? incidentType,
    required String location,
  }) {
    final type = (incidentType ?? 'Emergency').trim();
    return 'Proceed safely to $location. Keep dispatch updated every 5 minutes, '
        'prioritize life-saving actions for $type cases, and wait for clearance before closing the incident.';
  }

  Future<Incident> reportSos({
    String location = 'Current User Location',
    String details =
        'One-tap SOS activated by user. Immediate response requested.',
    String? disasterType,
    required String reporterName,
    required String reporterEmail,
    required String reporterRole,
  }) async {
    final now = DateTime.now();
    final id = _buildIncidentId(now);
    final userId = _auth.currentUser?.uid;
    final position = await _resolveCurrentPosition();
    final latitude = position?.latitude;
    final longitude = position?.longitude;
    if (latitude == null || longitude == null) {
      throw StateError(
        'Unable to fetch GPS coordinates. Please enable location services and permission.',
      );
    }
    final normalizedDisaster = disasterType?.trim();
    final hasDisaster =
        normalizedDisaster != null && normalizedDisaster.isNotEmpty;
    final title = hasDisaster
        ? 'SOS Alert - $normalizedDisaster'
        : 'SOS Emergency Alert';
    final description = hasDisaster
        ? 'SOS activated for $normalizedDisaster. Immediate response requested.'
        : details;
    final resolvedLocation = _formatLocation(
      latitude: latitude,
      longitude: longitude,
    );

    await _firestore.collection('sos_requests').doc(id).set({
      'incidentId': id,
      'status': 'pending',
      'severity': 'red',
      'incidentType': normalizedDisaster,
      'location': resolvedLocation,
      'details': description,
      'latitude': latitude,
      'longitude': longitude,
      'source': 'mobile_app',
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtClient': now.toIso8601String(),
      'syncedToDashboard': false,
      'reporter': {
        'uid': userId,
        'name': reporterName,
        'email': reporterEmail,
        'role': reporterRole,
      },
    }, SetOptions(merge: true));

    final incident = Incident(
      id: id,
      title: title,
      location: resolvedLocation,
      status: 'Critical',
      priority: 'Critical',
      reportedAt: now,
      description: description,
      assignedTeam: 'Dispatch Queue',
      incidentType: normalizedDisaster,
      reporterName: reporterName,
      reporterEmail: reporterEmail,
      latitude: latitude,
      longitude: longitude,
    );

    _incidents.insert(0, incident);
    notifyListeners();
    return incident;
  }

  Future<Position?> _resolveCurrentPosition() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return null;
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 12),
        ),
      );
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  String _formatLocation({
    required double latitude,
    required double longitude,
  }) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  String _buildIncidentId(DateTime time) {
    final suffix = Random().nextInt(900) + 100;
    return 'INC-${time.year}${time.month.toString().padLeft(2, '0')}${time.day.toString().padLeft(2, '0')}-$suffix';
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _volunteerAssignmentsSubscription?.cancel();
    super.dispose();
  }
}
