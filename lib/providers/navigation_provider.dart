import 'package:flutter/material.dart';

/// Navigation provider to manage current page and navigation state
/// Replicates the navigation functionality from the web app
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  String _currentRoute = '/dashboard';

  int get currentIndex => _currentIndex;
  String get currentRoute => _currentRoute;

  /// Navigation items matching the web app structure
  final List<NavigationItem> navigationItems = [
    NavigationItem(
      route: '/dashboard',
      label: 'Performance Dashboard',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      description: 'Track your progress and performance metrics',
    ),
    NavigationItem(
      route: '/wellness',
      label: 'Wellness',
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      description: 'Monitor your health and wellness data',
    ),
    NavigationItem(
      route: '/messages',
      label: 'Messages',
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      description: 'Chat with coaches and team members',
    ),
    NavigationItem(
      route: '/calendar',
      label: 'Calendar',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      description: 'View your training schedule',
    ),
    NavigationItem(
      route: '/devices',
      label: 'Devices',
      icon: Icons.smartphone_outlined,
      activeIcon: Icons.smartphone,
      description: 'Manage your connected devices',
    ),
  ];

  /// Update current navigation index
  void setCurrentIndex(int index) {
    if (index >= 0 && index < navigationItems.length) {
      _currentIndex = index;
      _currentRoute = navigationItems[index].route;
      notifyListeners();
    }
  }

  /// Update current route
  void setCurrentRoute(String route) {
    _currentRoute = route;
    final index = navigationItems.indexWhere((item) => item.route == route);
    if (index != -1) {
      _currentIndex = index;
    }
    notifyListeners();
  }

  /// Get navigation item by route
  NavigationItem? getItemByRoute(String route) {
    try {
      return navigationItems.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }
}

/// Navigation item model matching the web app structure
class NavigationItem {
  final String route;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String description;

  NavigationItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.description,
  });
}