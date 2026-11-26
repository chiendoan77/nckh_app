import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env.dart';
import '../../../core/network/dio_client.dart';
import 'api_auth_repository.dart';
import 'auth_repository.dart';
import 'mock_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => Env.useMock
      ? MockAuthRepository()
      : ApiAuthRepository(ref.watch(dioProvider)),
);
