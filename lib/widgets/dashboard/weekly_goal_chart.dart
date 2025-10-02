import 'package:flutter/material.dart';

/// Weekly Goal Chart widget that replicates the web app's progress tracking
class WeeklyGoalChart extends StatelessWidget {
  const WeeklyGoalChart({super.key});

  // Sample weekly progress data
  final List<Map<String, dynamic>> weeklyProgressData = const [
    {'week': 'W1', 'completed': 85, 'planned': 100},
    {'week': 'W2', 'completed': 92, 'planned': 100},
    {'week': 'W3', 'completed': 78, 'planned': 100},
    {'week': 'W4', 'completed': 95, 'planned': 100},
    {'week': 'W5', 'completed': 88, 'planned': 100},
    {'week': 'W6', 'completed': 97, 'planned': 100},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Weekly Goal Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Completed vs planned training sessions over the last 6 weeks',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(context, 'Completed (%)', Colors.green),
                _buildLegendItem(context, 'Planned (%)', Colors.green.withOpacity(0.3)),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Chart
            SizedBox(
              height: 300,
              child: CustomPaint(
                size: const Size(double.infinity, 300),
                painter: WeeklyGoalChartPainter(
                  data: weeklyProgressData,
                  theme: theme,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Summary Stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(context, 'Avg Completion', '89%', Icons.trending_up),
                  _buildSummaryItem(context, 'Best Week', 'W6 (97%)', Icons.emoji_events),
                  _buildSummaryItem(context, 'Streak', '3 weeks', Icons.local_fire_department),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: theme.primaryColor,
          size: 18,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class WeeklyGoalChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final ThemeData theme;

  WeeklyGoalChartPainter({required this.data, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    final barWidth = (size.width - 60) / data.length;
    final maxHeight = size.height - 60;
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = theme.colorScheme.outline.withOpacity(0.2)
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 5; i++) {
      final y = maxHeight - (i * maxHeight / 5) + 30;
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width - 30, y),
        gridPaint,
      );
      
      // Y-axis labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i * 20}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }
    
    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final x = 30 + i * barWidth + barWidth * 0.1;
      final plannedHeight = (item['planned'] / 100.0) * maxHeight;
      final completedHeight = (item['completed'] / 100.0) * maxHeight;
      
      // Planned bar (background)
      paint.color = Colors.green.withOpacity(0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            size.height - 30 - plannedHeight,
            barWidth * 0.8,
            plannedHeight,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
      
      // Completed bar (foreground)
      paint.color = Colors.green;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            size.height - 30 - completedHeight,
            barWidth * 0.8,
            completedHeight,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
      
      // Week label
      final textPainter = TextPainter(
        text: TextSpan(
          text: item['week'],
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x + (barWidth * 0.8 - textPainter.width) / 2,
          size.height - 20,
        ),
      );
      
      // Completion percentage
      final percentText = TextPainter(
        text: TextSpan(
          text: '${item['completed']}%',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      percentText.layout();
      if (completedHeight > 20) {
        percentText.paint(
          canvas,
          Offset(
            x + (barWidth * 0.8 - percentText.width) / 2,
            size.height - 30 - completedHeight / 2 - percentText.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}