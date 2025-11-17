import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data; // label -> value
  final Map<String, Color> colors; // label -> color

  const PieChartWidget({
    Key? key,
    required this.data,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
        ),
      );
    }

    final total = data.values.reduce((a, b) => a + b);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: _getSections(total),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              startDegreeOffset: -90,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLegend(total),
      ],
    );
  }

  List<PieChartSectionData> _getSections(double total) {
    return data.entries.map((entry) {
      final percentage = (entry.value / total * 100);
      final color = colors[entry.key] ?? AppColors.pinkPrimary;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        color: color,
        radius: 60,
        titleStyle: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(double total) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: data.entries.map((entry) {
        final percentage = (entry.value / total * 100).toStringAsFixed(1);
        final color = colors[entry.key] ?? AppColors.pinkPrimary;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${entry.key}: ${entry.value.toStringAsFixed(0)}g ($percentage%)',
              style: AppTextStyles.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}
