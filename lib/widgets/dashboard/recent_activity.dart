import 'package:flutter/material.dart';

/// Recent Activity widget that replicates the web app's activity timeline
class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  // Sample recent activity data
  final List<Map<String, dynamic>> recentActivities = const [
    {
      'type': 'workout',
      'title': 'Morning HIIT Session',
      'time': '2 hours ago',
      'duration': '45 min',
      'calories': '420 kcal',
      'icon': Icons.flash_on,
      'color': Colors.orange,
      'details': 'High intensity interval training with 8 rounds',
    },
    {
      'type': 'measurement',
      'title': 'Heart Rate Variability Check',
      'time': '4 hours ago',
      'value': '42 ms',
      'status': 'Good',
      'icon': Icons.favorite,
      'color': Colors.red,
      'details': 'HRV measurement indicates good recovery state',
    },
    {
      'type': 'goal',
      'title': 'Weekly Step Goal Achieved',
      'time': '6 hours ago',
      'progress': '50,000 steps',
      'achievement': '105% of target',
      'icon': Icons.emoji_events,
      'color': Colors.amber,
      'details': 'Exceeded weekly step goal by 2,500 steps',
    },
    {
      'type': 'workout',
      'title': 'Strength Training',
      'time': '1 day ago',
      'duration': '60 min',
      'calories': '380 kcal',
      'icon': Icons.fitness_center,
      'color': Colors.blue,
      'details': 'Upper body strength training session',
    },
    {
      'type': 'recovery',
      'title': 'Recovery Session Completed',
      'time': '1 day ago',
      'duration': '30 min',
      'type_detail': 'Stretching & Meditation',
      'icon': Icons.spa,
      'color': Colors.green,
      'details': 'Post-workout recovery with guided stretching',
    },
    {
      'type': 'measurement',
      'title': 'Muscle Fatigue Analysis',
      'time': '2 days ago',
      'value': '68%',
      'status': 'Moderate',
      'icon': Icons.analytics,
      'color': Colors.purple,
      'details': 'EMG analysis shows moderate muscle fatigue levels',
    },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Your latest workouts, measurements, and achievements',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full activity history
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Full activity history coming soon!')),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Activity Timeline
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = recentActivities[index];
                return _buildActivityItem(context, activity);
              },
            ),
            
            const SizedBox(height: 16),
            
            // Quick Stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat(context, '6', 'Activities\nThis Week', Icons.event),
                  _buildQuickStat(context, '4.2', 'Avg Session\nRating', Icons.star),
                  _buildQuickStat(context, '85%', 'Goal\nCompletion', Icons.track_changes),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, Map<String, dynamic> activity) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => _showActivityDetails(context, activity),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Activity Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activity['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                activity['icon'],
                color: activity['color'],
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Activity Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity['time'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  if (_getActivitySubtitle(activity) != null) ...
                  [
                    const SizedBox(height: 2),
                    Text(
                      _getActivitySubtitle(activity)!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: activity['color'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Status Indicator
            _buildStatusIndicator(context, activity),
          ],
        ),
      ),
    );
  }

  String? _getActivitySubtitle(Map<String, dynamic> activity) {
    switch (activity['type']) {
      case 'workout':
        return '${activity['duration']} • ${activity['calories']}';
      case 'measurement':
        return '${activity['value']} • ${activity['status']}';
      case 'goal':
        return '${activity['progress']} • ${activity['achievement']}';
      case 'recovery':
        return '${activity['duration']} • ${activity['type_detail']}';
      default:
        return null;
    }
  }

  Widget _buildStatusIndicator(BuildContext context, Map<String, dynamic> activity) {
    switch (activity['type']) {
      case 'workout':
        return Icon(Icons.check_circle, color: Colors.green, size: 16);
      case 'measurement':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: activity['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            activity['status'],
            style: TextStyle(
              color: activity['color'],
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'goal':
        return Icon(Icons.celebration, color: Colors.amber, size: 16);
      default:
        return const SizedBox();
    }
  }

  Widget _buildQuickStat(BuildContext context, String value, String label, IconData icon) {
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
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  void _showActivityDetails(BuildContext context, Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: activity['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        activity['icon'],
                        color: activity['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            activity['time'],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Details
                Text(
                  'Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activity['details'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Detailed view coming soon!')),
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}