import 'user_role.dart';

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    this.approvalStatus = 'approved',
  });

  final String name;
  final String email;
  final UserRole role;
  final String approvalStatus;

  bool get isApproved => approvalStatus.toLowerCase() == 'approved';
}
