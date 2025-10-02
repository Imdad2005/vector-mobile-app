import 'package:flutter/material.dart';

/// Performance Charts widget that replicates the web app's chart functionality
class PerformanceCharts extends StatelessWidget {
  const PerformanceCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeartRateChart(context),
        const SizedBox(height: 16),
        _buildActivityChart(context),
      ],
    );
  }

  Widget _buildHeartRateChart(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Heart Rate Trend',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Last 7 days',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Placeholder chart area
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Simulated heart rate line
                  CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: HeartRateChartPainter(theme.colorScheme.primary),
                  ),
                  
                  // Chart labels
                  Positioned(
                    bottom: 8,
                    left: 16,
                    child: Text(
                      'Mon',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 16,
                    child: Text(
                      'Sun',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 16,
                    child: Text(
                      'Max: 165 BPM',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Chart legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(context, 'Resting', '62 BPM', Colors.blue),
                _buildLegendItem(context, 'Average', '85 BPM', Colors.orange),
                _buildLegendItem(context, 'Peak', '165 BPM', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Activity bars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildActivityBar(context, 'Mon', 0.8, Colors.green),
                _buildActivityBar(context, 'Tue', 0.6, Colors.blue),
                _buildActivityBar(context, 'Wed', 0.9, Colors.green),
                _buildActivityBar(context, 'Thu', 0.4, Colors.orange),
                _buildActivityBar(context, 'Fri', 0.7, Colors.blue),
                _buildActivityBar(context, 'Sat', 0.9, Colors.green),
                _buildActivityBar(context, 'Sun', 0.3, Colors.red),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Goal: 10,000 steps/day',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    
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
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall,
            ),
            Text(
              value,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityBar(BuildContext context, String day, double progress, Color color) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 24,
          height: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 24,
              height: 100 * progress,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

/// Custom painter for heart rate chart
class HeartRateChartPainter extends CustomPainter {
  final Color color;
  
  HeartRateChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Simulate heart rate data points
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.45, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.8),
    ];

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}