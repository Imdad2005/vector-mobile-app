import 'package:flutter/material.dart';

/// Heat Map widget that replicates the web app's activity intensity visualization
class HeatMap extends StatelessWidget {
  const HeatMap({super.key});

  // Sample heat map data (7 days × 24 hours)
  final List<List<int>> heatMapData = const [
    [0, 0, 0, 0, 0, 0, 2, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 2, 0, 0, 0, 0], // Mon
    [0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 2, 0, 0, 0], // Tue
    [0, 0, 0, 0, 0, 0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0], // Wed
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 1, 0, 0, 0], // Thu
    [0, 0, 0, 0, 0, 0, 2, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0], // Fri
    [0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0], // Sat
    [0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // Sun
  ];

  final List<String> dayLabels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
              'Activity Heat Map',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Training intensity patterns throughout the week (hourly breakdown)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Less',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Row(
                  children: List.generate(4, (intensity) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: _getIntensityColor(context, intensity),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )),
                ),
                Text(
                  'More',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Heat Map Grid
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Hour labels
                  Row(
                    children: [
                      const SizedBox(width: 40), // Space for day labels
                      ...List.generate(24, (hour) => Container(
                        width: 16,
                        alignment: Alignment.center,
                        child: hour % 6 == 0 ? Text(
                          hour.toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ) : null,
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Heat map rows
                  ...List.generate(7, (dayIndex) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        // Day label
                        SizedBox(
                          width: 40,
                          child: Text(
                            dayLabels[dayIndex],
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ),
                        // Hour cells
                        ...List.generate(24, (hourIndex) => GestureDetector(
                          onTap: () => _showActivityDetails(context, dayIndex, hourIndex),
                          child: Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: _getIntensityColor(context, heatMapData[dayIndex][hourIndex]),
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Summary Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, 'Active Hours', '28', Icons.schedule),
                _buildStatItem(context, 'Peak Time', '7-9 AM', Icons.trending_up),
                _buildStatItem(context, 'Rest Days', '2', Icons.bedtime),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getIntensityColor(BuildContext context, int intensity) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    switch (intensity) {
      case 0:
        return isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
      case 1:
        return isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDDD6FE); // Light blue
      case 2:
        return isDark ? const Color(0xFF2563EB) : const Color(0xFF8B5CF6); // Medium blue
      case 3:
        return isDark ? const Color(0xFF3B82F6) : const Color(0xFF6366F1); // Bright blue
      default:
        return isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
    }
  }

  String _getIntensityLabel(int intensity) {
    switch (intensity) {
      case 0:
        return 'No activity';
      case 1:
        return 'Light activity';
      case 2:
        return 'Moderate activity';
      case 3:
        return 'High intensity';
      default:
        return 'No activity';
    }
  }

  void _showActivityDetails(BuildContext context, int dayIndex, int hourIndex) {
    final intensity = heatMapData[dayIndex][hourIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dayLabels[dayIndex]} ${hourIndex}:00'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Level: ${_getIntensityLabel(intensity)}'),
            const SizedBox(height: 8),
            if (intensity > 0) ...
            [
              Text('Duration: ${intensity * 15} minutes'),
              Text('Calories: ${intensity * 25} kcal'),
              Text('Heart Rate: ${60 + intensity * 20} BPM'),
            ] else
              const Text('No recorded activity during this hour.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: theme.primaryColor,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
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