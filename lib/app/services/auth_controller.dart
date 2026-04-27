import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSubscription;
  AppUser? _user;
  bool _booting = true;

  AppUser? get user => _user;
  bool get booting => _booting;

  Future<void> bootstrap() async {
    await _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((firebaseUser) async {
      try {
        await _syncAppUser(firebaseUser);
      } catch (_) {
        _user = null;
        _booting = false;
        notifyListeners();
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'signup-failed',
        message: 'Unable to create user account.',
      );
    }

    final trimmedName = name.trim();
    await firebaseUser.updateDisplayName(trimmedName);

    await _firestore.collection('users').doc(firebaseUser.uid).set({
      'name': trimmedName,
      'email': email.trim().toLowerCase(),
      'role': role.storageValue,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _syncAppUser(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _booting = false;
      notifyListeners();
      return;
    }

    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await docRef.get();
    final data = snapshot.data();

    final resolvedRole = userRoleFromStorage(data?['role'] as String?);
    final resolvedEmail =
        (firebaseUser.email ?? (data?['email'] as String? ?? '')).trim();
    final resolvedName =
        ((data?['name'] as String?) ??
                firebaseUser.displayName ??
                'Relief User')
            .trim();

    if (!snapshot.exists) {
      await docRef.set({
        'name': resolvedName,
        'email': resolvedEmail.toLowerCase(),
        'role': resolvedRole.storageValue,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await docRef.set({
        'name': resolvedName,
        'email': resolvedEmail.toLowerCase(),
        'role': resolvedRole.storageValue,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    _user = AppUser(
      name: resolvedName,
      email: resolvedEmail,
      role: resolvedRole,
    );
    _booting = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
