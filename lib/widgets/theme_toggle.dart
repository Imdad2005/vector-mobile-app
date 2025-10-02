import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Theme toggle widget that replicates the web app's theme switching functionality
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return IconButton(
      onPressed: () => themeProvider.toggleTheme(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          themeProvider.isDarkMode 
            ? Icons.light_mode_outlined
            : Icons.dark_mode_outlined,
          key: ValueKey(themeProvider.isDarkMode),
        ),
      ),
      tooltip: themeProvider.isDarkMode 
        ? 'Switch to light mode'
        : 'Switch to dark mode',
    );
  }
}