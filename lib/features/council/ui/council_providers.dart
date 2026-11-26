import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_council_repository.dart';
import '../data/council.dart';
import '../data/council_repository.dart';
import '../data/mock_council_repository.dart';

final councilRepositoryProvider = Provider<CouncilRepository>(
  (ref) => Env.useMock
      ? MockCouncilRepository()
      : ApiCouncilRepository(ref.watch(dioProvider)),
);

final councilsProvider = FutureProvider.autoDispose<List<Council>>(
  (ref) => ref.watch(councilRepositoryProvider).list(),
);
