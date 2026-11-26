import '../../../core/auth/session.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/network/api_error.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    for (final account in seedAccounts) {
      if (account.username == username && account.password == password) {
        return Session(
          token: account.token,
          user: account.user,
          activeRole: account.user.role,
        );
      }
    }
    throw ApiError(401, 'Sai tên đăng nhập hoặc mật khẩu');
  }
}
