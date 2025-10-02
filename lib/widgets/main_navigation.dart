import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/theme_toggle.dart';

/// Main navigation widget that replicates the mobile header from the web app
/// Includes the Vector logo, title, and hamburger menu for mobile navigation
class MainNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final String? badgeText;
  final Widget? badgeIcon;
  final bool showActions;
  final Widget? child;

  const MainNavigation({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.badgeText,
    this.badgeIcon,
    this.showActions = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      scrolledUnderElevation: theme.appBarTheme.scrolledUnderElevation,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vector Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: icon ?? const Icon(
              Icons.bolt,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          // Title
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Vector',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: showActions ? [
        // Theme toggle
        const ThemeToggle(),
        const SizedBox(width: 8),
        // Notifications (placeholder)
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 8),
      ] : null,
      // Custom hamburger menu button
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => _showMobileMenu(context),
          icon: const Icon(Icons.menu),
          tooltip: 'Navigation Menu',
        ),
      ),
    );
  }

  /// Show mobile navigation menu drawer (replicates web app's mobile drawer)
  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const MobileNavigationDrawer(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Mobile navigation drawer that replicates the web app's mobile drawer
class MobileNavigationDrawer extends StatelessWidget {
  const MobileNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationProvider = Provider.of<NavigationProvider>(context);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drawer Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Navigation',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                tooltip: 'Close',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Navigation Items
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: navigationProvider.navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationProvider.navigationItems[index];
                final isActive = navigationProvider.currentRoute == item.route;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isActive 
                          ? const Color(0xFF2563EB).withOpacity(0.1)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive 
                          ? const Color(0xFF2563EB)
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    title: Text(
                      item.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive 
                          ? const Color(0xFF2563EB)
                          : theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      navigationProvider.setCurrentRoute(item.route);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(item.route);
                    },
                  ),
                );
              },
            ),
          ),
          
          // Theme toggle section (like in web app)
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Theme',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const ThemeToggle(),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}