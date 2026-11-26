import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/user_role.dart';
import 'user.dart';

class Session {
  const Session({
    required this.token,
    required this.user,
    required this.activeRole,
  });

  final String token;
  final User user;
  final UserRole activeRole;

  Session withRole(UserRole role) =>
      Session(token: token, user: user, activeRole: role);
}

class SessionNotifier extends Notifier<Session?> {
  @override
  Session? build() => null;

  void login(String token, User user, UserRole role) {
    state = Session(token: token, user: user, activeRole: role);
  }

  void switchRole(UserRole role) {
    state = state?.withRole(role);
  }

  void logout() {
    state = null;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, Session?>(
  SessionNotifier.new,
);
