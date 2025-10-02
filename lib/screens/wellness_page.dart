import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_navigation.dart';
import '../providers/navigation_provider.dart';
import '../widgets/wellness/daily_checkin.dart';

/// Wellness page that replicates the web app's wellness monitoring
class WellnessPage extends StatelessWidget {
  const WellnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Update navigation provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentRoute('/wellness');
    });

    return Scaffold(
      appBar: const MainNavigation(
        title: 'Vector',
        subtitle: 'Wellness',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Text(
              'Wellness Dashboard',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Monitor your daily wellness metrics and recovery status.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Today's Check-in Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Daily Check-in',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'How are you feeling today?',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // Mood Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMoodButton(context, '😴', 'Tired', false),
                        _buildMoodButton(context, '😊', 'Good', true),
                        _buildMoodButton(context, '💪', 'Strong', false),
                        _buildMoodButton(context, '🔥', 'Energetic', false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Wellness Metrics
            Row(
              children: [
                Expanded(
                  child: _buildWellnessCard(
                    context,
                    title: 'Sleep Quality',
                    value: '85%',
                    icon: Icons.bedtime,
                    color: Colors.purple,
                    subtitle: '7.5 hrs last night',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWellnessCard(
                    context,
                    title: 'Stress Level',
                    value: 'Low',
                    icon: Icons.psychology,
                    color: Colors.green,
                    subtitle: 'Well managed',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildWellnessCard(
                    context,
                    title: 'Hydration',
                    value: '1.8L',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                    subtitle: 'Goal: 2.5L',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWellnessCard(
                    context,
                    title: 'Recovery',
                    value: '92%',
                    icon: Icons.trending_up,
                    color: Colors.orange,
                    subtitle: 'Excellent',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Weekly Trends
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Wellness Trends',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTrendItem(context, 'Sleep Quality', '↗️', '+12%', Colors.green),
                    const SizedBox(height: 12),
                    _buildTrendItem(context, 'Stress Management', '↗️', '+8%', Colors.green),
                    const SizedBox(height: 12),
                    _buildTrendItem(context, 'Recovery Time', '↘️', '-15%', Colors.green),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, String emoji, String label, bool isSelected) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected 
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSelected 
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildWellnessCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(BuildContext context, String metric, String emoji, String change, Color color) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          metric,
          style: theme.textTheme.bodyMedium,
        ),
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              change,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}