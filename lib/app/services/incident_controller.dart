import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../data/mock_data.dart';
import '../models/incident.dart';

class IncidentController extends ChangeNotifier {
  IncidentController() : _incidents = List<Incident>.from(MockData.incidents);

  final List<Incident> _incidents;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Incident> get incidents => List.unmodifiable(_incidents);

  Incident? get latestIncident => _incidents.isEmpty ? null : _incidents.first;

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
      fallbackLocation: location,
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
    required String fallbackLocation,
    required double? latitude,
    required double? longitude,
  }) {
    if (latitude == null || longitude == null) {
      return fallbackLocation;
    }
    return 'Lat ${latitude.toStringAsFixed(6)}, Lng ${longitude.toStringAsFixed(6)}';
  }

  String _buildIncidentId(DateTime time) {
    final suffix = Random().nextInt(900) + 100;
    return 'INC-${time.year}${time.month.toString().padLeft(2, '0')}${time.day.toString().padLeft(2, '0')}-$suffix';
  }
}
