import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_navigation.dart';
import '../providers/navigation_provider.dart';

/// Messages page that replicates the web app's messaging system
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Update navigation provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentRoute('/messages');
    });

    return Scaffold(
      appBar: const MainNavigation(
        title: 'Vector',
        subtitle: 'Messages',
      ),
      body: Column(
        children: [
          // Page Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chat with your healthcare team and coaches.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // Chat List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChatItem(
                  context,
                  name: 'Dr. Sarah Johnson',
                  subtitle: 'Cardiologist',
                  lastMessage: 'Your latest ECG results look great! Keep up the good work.',
                  time: '2h ago',
                  isOnline: true,
                  avatar: Icons.medical_services,
                  avatarColor: Colors.red,
                ),
                
                _buildChatItem(
                  context,
                  name: 'Coach Mike',
                  subtitle: 'Fitness Coach',
                  lastMessage: 'Ready for tomorrow\'s training session?',
                  time: '4h ago',
                  isOnline: true,
                  avatar: Icons.fitness_center,
                  avatarColor: Colors.orange,
                ),
                
                _buildChatItem(
                  context,
                  name: 'Emma Wilson',
                  subtitle: 'Nutritionist',
                  lastMessage: 'I\'ve updated your meal plan. Check it out!',
                  time: '1d ago',
                  isOnline: false,
                  avatar: Icons.restaurant,
                  avatarColor: Colors.green,
                ),
                
                _buildChatItem(
                  context,
                  name: 'Dr. Lisa Chen',
                  subtitle: 'Sports Psychologist',
                  lastMessage: 'How are you feeling about the competition?',
                  time: '2d ago',
                  isOnline: false,
                  avatar: Icons.psychology,
                  avatarColor: Colors.purple,
                ),
                
                _buildChatItem(
                  context,
                  name: 'Support Team',
                  subtitle: 'Vector Belt Support',
                  lastMessage: 'Your device firmware has been updated successfully.',
                  time: '3d ago', 
                  isOnline: true,
                  avatar: Icons.support_agent,
                  avatarColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New chat feature coming soon!')),
          );
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String subtitle,
    required String lastMessage,
    required String time,
    required bool isOnline,
    required IconData avatar,
    required Color avatarColor,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(avatar, color: avatarColor, size: 24),
            ),
            if (isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lastMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Text(
          time,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening chat with $name...')),
          );
        },
      ),
    );
  }
}