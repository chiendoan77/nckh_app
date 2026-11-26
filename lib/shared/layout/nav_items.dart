import 'package:flutter/material.dart';

import '../../app/router/paths.dart';
import '../../core/constants/user_role.dart';

class NavItem {
  const NavItem(this.label, this.path, this.icon);

  final String label;
  final String path;
  final IconData icon;
}

const navItemsByRole = <UserRole, List<NavItem>>{
  UserRole.student: [
    NavItem('Đăng ký đề tài', Paths.studentTopics, Icons.assignment_outlined),
    NavItem('Tra cứu điểm', Paths.studentGrades, Icons.grade_outlined),
  ],
  UserRole.teacher: [
    NavItem('Công việc', Paths.teacherActive, Icons.work_outline),
    NavItem('Hoàn thành', Paths.teacherCompleted, Icons.check_circle_outline),
  ],
  UserRole.manager: [
    NavItem('Danh sách đề tài', Paths.managerTopics, Icons.list_alt_outlined),
    NavItem('Hội đồng chấm', Paths.managerCouncils, Icons.groups_outlined),
    NavItem('Thống kê', Paths.managerStats, Icons.pie_chart_outline),
  ],
  UserRole.admin: [
    NavItem('Sinh viên', Paths.adminStudents, Icons.school_outlined),
    NavItem('Giảng viên', Paths.adminTeachers, Icons.person_outline),
  ],
};
