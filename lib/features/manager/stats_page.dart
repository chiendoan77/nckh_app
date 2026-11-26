import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_tokens.dart';
import '../../core/constants/topic_status.dart';
import '../../core/network/api_error.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/pie_chart_box.dart';
import '../../shared/widgets/state_views.dart';
import '../../features/stats/ui/stats_providers.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  bool _isExporting = false;

  Future<void> _exportExcel() async {
    if (_isExporting) {
      return;
    }
    setState(() => _isExporting = true);
    try {
      await ref.read(statsRepositoryProvider).exportExcel();
      if (mounted) {
        AppToast.success(context, 'Xuất tệp Excel thành công.');
      }
    } on ApiError catch (error) {
      if (mounted) {
        AppToast.error(context, error.message);
      }
    } on Exception catch (error) {
      if (mounted) {
        AppToast.error(context, error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(topicStatsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Thống kê đề tài',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              AppButton(
                label: _isExporting ? 'Đang xuất…' : 'Xuất EXCEL',
                onPressed: _isExporting ? null : _exportExcel,
              ),
            ],
          ),
        ),
        Expanded(
          child: stats.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              message: '$error',
              onRetry: () => ref.invalidate(topicStatsProvider),
            ),
            data: (value) {
              if (value.cancelled + value.approved + value.late == 0) {
                return const EmptyView('Chưa có dữ liệu thống kê.');
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: PieChartBox(
                  slices: [
                    PieSlice(
                      label: 'HỦY',
                      value: value.cancelled,
                      color: AppTokens.statusColor(TopicStatus.cancelled),
                    ),
                    PieSlice(
                      label: 'DUYỆT',
                      value: value.approved,
                      color: AppTokens.statusColor(TopicStatus.approved),
                    ),
                    PieSlice(
                      label: 'TRỄ',
                      value: value.late,
                      color: AppTokens.statusColor(TopicStatus.pending),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
