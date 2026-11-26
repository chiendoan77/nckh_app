import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/session.dart';
import '../../core/constants/user_role.dart';
import '../../features/admin/student_manage_page.dart';
import '../../features/admin/teacher_manage_page.dart';
import '../../features/auth/ui/login_page.dart';
import '../../features/common/error_page.dart';
import '../../features/common/intro_page.dart';
import '../../features/manager/council_page.dart';
import '../../features/manager/stats_page.dart';
import '../../features/manager/topic_review_page.dart';
import '../../features/student/grade_lookup_page.dart';
import '../../features/student/topic_register_page.dart';
import '../../features/teacher/active_topics_page.dart';
import '../../features/teacher/completed_topics_page.dart';
import '../../shared/layout/app_shell.dart';
import '../../shared/widgets/state_views.dart';
import '../../features/user/ui/profile_panel.dart';
import 'paths.dart';
import 'role_access.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionProvider, (_, _) => refresh.value++);

  late final GoRouter router;
  router = GoRouter(
    initialLocation: Paths.intro,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;
      final isPublic = location == Paths.intro || location == Paths.login;

      if (session == null) {
        return isPublic ? null : Paths.login;
      }
      if (isPublic) {
        return homeOf(session.activeRole);
      }

      final requiredRole = roleForPath(location);
      if (requiredRole != null && requiredRole != session.activeRole) {
        return Paths.forbidden;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Paths.intro,
        builder: (context, _) =>
            IntroPage(onLogin: () => context.go(Paths.login)),
      ),
      GoRoute(path: Paths.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: Paths.forbidden,
        builder: (_, _) => ErrorPage.forbidden(
          onHome: () {
            final session = ref.read(sessionProvider);
            router.go(
              session == null ? Paths.login : homeOf(session.activeRole),
            );
          },
        ),
      ),
      ShellRoute(
        builder: (_, _, child) => AppShell(
          child: child,
          profileBuilder: (context, session) {
            final studentId = session.user.studentId;
            if (session.activeRole == UserRole.student) {
              return studentId == null
                  ? const EmptyView('Không tìm thấy mã sinh viên.')
                  : ProfilePanel(studentId: studentId);
            }
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(session.activeRole.label),
                ],
              ),
            );
          },
        ),
        routes: [
          GoRoute(
            path: Paths.studentTopics,
            builder: (_, _) => const TopicRegisterPage(),
          ),
          GoRoute(
            path: Paths.studentGrades,
            builder: (_, _) => const GradeLookupPage(),
          ),
          GoRoute(
            path: Paths.teacherActive,
            builder: (_, _) => const ActiveTopicsPage(),
          ),
          GoRoute(
            path: Paths.teacherCompleted,
            builder: (_, _) => const CompletedTopicsPage(),
          ),
          GoRoute(
            path: Paths.managerTopics,
            builder: (_, _) => const TopicReviewPage(),
          ),
          GoRoute(
            path: Paths.managerCouncils,
            builder: (_, _) => const CouncilPage(),
          ),
          GoRoute(
            path: Paths.managerStats,
            builder: (_, _) => const StatsPage(),
          ),
          GoRoute(
            path: Paths.adminStudents,
            builder: (_, _) => const StudentManagePage(),
          ),
          GoRoute(
            path: Paths.adminTeachers,
            builder: (_, _) => const TeacherManagePage(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, _) => ErrorPage.notFound(
      onHome: () {
        final session = ref.read(sessionProvider);
        router.go(session == null ? Paths.login : homeOf(session.activeRole));
      },
    ),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
