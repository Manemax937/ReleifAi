enum UserRole { victim, volunteer }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.victim:
        return 'Victim';
      case UserRole.volunteer:
        return 'Volunteer';
    }
  }
}

extension UserRoleStorage on UserRole {
  String get storageValue => name;
}

UserRole userRoleFromStorage(String? value) {
  switch (value?.toLowerCase()) {
    case 'volunteer':
      return UserRole.volunteer;
    case 'victim':
    default:
      return UserRole.victim;
  }
}
