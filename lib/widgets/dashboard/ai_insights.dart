import 'package:flutter/material.dart';

/// AI Insights widget that replicates the web app's AI-powered recommendations
class AIInsights extends StatelessWidget {
  const AIInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // AI Analysis Card
          _buildAIAnalysisCard(context),
          
          const SizedBox(height: 16),
          
          // Recommendations
          _buildRecommendationsCard(context),
          
          const SizedBox(height: 16),
          
          // Performance Trends
          _buildTrendsCard(context),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Performance Analysis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Performance Score',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '87',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/100',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Excellent',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Progress bar
                  LinearProgressIndicator(
                    value: 0.87,
                    backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Key Insights',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            _buildInsightItem(
              context,
              '• Your heart rate variability has improved by 12% this week',
              Colors.green,
            ),
            _buildInsightItem(
              context,
              '• Muscle recovery time has decreased from 48h to 36h',
              Colors.blue,
            ),
            _buildInsightItem(
              context,
              '• Sleep quality directly correlates with your performance',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Recommendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildRecommendationItem(
              context,
              title: 'Optimize Recovery',
              description: 'Consider adding 15 minutes of stretching after workouts',
              priority: 'High',
              priorityColor: Colors.red,
            ),
            
            const SizedBox(height: 12),
            
            _buildRecommendationItem(
              context,
              title: 'Hydration Reminder',
              description: 'Your performance drops after 2 PM - increase water intake',
              priority: 'Medium',
              priorityColor: Colors.orange,
            ),
            
            const SizedBox(height: 12),
            
            _buildRecommendationItem(
              context,
              title: 'Sleep Schedule',
              description: 'Consistent bedtime at 10 PM could improve HRV by 8%',
              priority: 'Low',
              priorityColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Trends',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildTrendItem(
              context,
              metric: 'Cardiovascular Fitness',
              trend: '+15%',
              period: 'Last 30 days',
              isPositive: true,
            ),
            
            const SizedBox(height: 12),
            
            _buildTrendItem(
              context,
              metric: 'Muscle Strength',
              trend: '+8%',
              period: 'Last 14 days',
              isPositive: true,
            ),
            
            const SizedBox(height: 12),
            
            _buildTrendItem(
              context,
              metric: 'Recovery Time',
              trend: '-23%',
              period: 'Last 7 days',
              isPositive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, String text, Color color) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context, {
    required String title,
    required String description,
    required String priority,
    required Color priorityColor,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(
    BuildContext context, {
    required String metric,
    required String trend,
    required String period,
    required bool isPositive,
  }) {
    final theme = Theme.of(context);
    final trendColor = isPositive ? Colors.green : Colors.red;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                period,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: trendColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              trend,
              style: theme.textTheme.titleSmall?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}