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
    NavItem('Đăng ký đề tài', Paths.studentTopics, Icons.app_registration),
    NavItem('Tra cứu điểm', Paths.studentGrades, Icons.grade),
  ],
  UserRole.teacher: [
    NavItem('Công việc', Paths.teacherActive, Icons.work_outline),
    NavItem('Hoàn thành', Paths.teacherCompleted, Icons.task_alt),
  ],
  UserRole.manager: [
    NavItem('Danh sách đề tài', Paths.managerTopics, Icons.list_alt),
    NavItem('Hội đồng chấm', Paths.managerCouncils, Icons.groups),
    NavItem('Thống kê', Paths.managerStats, Icons.pie_chart_outline),
  ],
  UserRole.admin: [
    NavItem('Sinh viên', Paths.adminStudents, Icons.school),
    NavItem('Giảng viên', Paths.adminTeachers, Icons.person_pin),
  ],
};
