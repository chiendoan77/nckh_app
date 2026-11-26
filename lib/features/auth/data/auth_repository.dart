import '../../../core/auth/session.dart';

abstract class AuthRepository {
  Future<Session> login({required String username, required String password});
}
