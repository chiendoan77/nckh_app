import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieSlice {
  const PieSlice({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}

class PieChartBox extends StatelessWidget {
  const PieChartBox({super.key, required this.slices});

  final List<PieSlice> slices;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final chart = SizedBox(
        width: 280,
        height: 260,
        child: Semantics(
          label: 'Biểu đồ thống kê đề tài',
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              sections: slices
                  .map(
                    (slice) => PieChartSectionData(
                      value: slice.value.toDouble(),
                      color: slice.color,
                      radius: 92,
                      showTitle: false,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
      final details = _buildDetails(context);
      return constraints.maxWidth >= 760
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                chart,
                const SizedBox(width: 24),
                Expanded(child: details),
              ],
            )
          : Column(children: [chart, details]);
    },
  );

  Widget _buildDetails(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final slice in slices)
        Tooltip(
          message: '${slice.label}: ${slice.value}',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(width: 16, height: 16, color: slice.color),
                const SizedBox(width: 12),
                Expanded(child: Text(slice.label)),
                Text(
                  '${slice.value}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      const Divider(),
      Table(
        columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(1)},
        children: [
          const TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Trạng thái'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Số lượng'),
              ),
            ],
          ),
          for (final slice in slices)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(slice.label),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('${slice.value}'),
                ),
              ],
            ),
        ],
      ),
    ],
  );
}
