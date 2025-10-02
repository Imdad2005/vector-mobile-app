import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_navigation.dart';
import '../providers/navigation_provider.dart';

/// Calendar page that replicates the web app's calendar functionality
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime selectedDate;
  late DateTime focusedDate;
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    focusedDate = DateTime(now.year, now.month, now.day);
    
    // Debug print to verify initialization
    print('Calendar initialized - Today: $now, Selected: $selectedDate, Focused: $focusedDate');
  }

  final Map<DateTime, List<TrainingEvent>> events = {
    DateTime(2025, 10, 1): [
      TrainingEvent('Morning Cardio', '7:00 AM', 'Completed', Colors.green),
      TrainingEvent('Strength Training', '6:00 PM', 'Scheduled', Colors.blue),
    ],
    DateTime(2025, 10, 2): [
      TrainingEvent('Recovery Session', '8:00 AM', 'Scheduled', Colors.orange),
    ],
    DateTime(2025, 10, 3): [
      TrainingEvent('HIIT Workout', '7:00 AM', 'Scheduled', Colors.red),
      TrainingEvent('Flexibility Training', '7:00 PM', 'Scheduled', Colors.purple),
    ],
    DateTime(2025, 10, 5): [
      TrainingEvent('Long Run', '6:00 AM', 'Scheduled', Colors.blue),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Update navigation provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentRoute('/calendar');
    });

    return Scaffold(
      appBar: const MainNavigation(
        title: 'Vector',
        subtitle: 'Calendar',
      ),
      body: Column(
        children: [
          // Calendar Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      focusedDate = DateTime(
                        focusedDate.year,
                        focusedDate.month - 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${_getMonthName(focusedDate.month)} ${focusedDate.year}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      focusedDate = DateTime(
                        focusedDate.year,
                        focusedDate.month + 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // Calendar Grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Days of week header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                          .map((day) => Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Calendar Days
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildCalendarGrid(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Selected Date Events
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isSameDay(selectedDate, DateTime.now())
                                  ? 'Today\'s Events'
                                  : 'Events for ${_getMonthName(selectedDate.month)} ${selectedDate.day}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (events[_getDateOnly(selectedDate)]?.isNotEmpty == true)
                          Column(
                            children: events[_getDateOnly(selectedDate)]!
                                .map((event) => _buildEventCard(event))
                                .toList(),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'No events scheduled for this day',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    
    // Convert DateTime.weekday (1=Monday, 7=Sunday) to calendar format (0=Sunday, 6=Saturday)
    // DateTime.weekday: 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday, 7=Sunday
    // Calendar needs: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
    final firstWeekday = firstDayOfMonth.weekday % 7;
    
    // Debug info for October 2025
    if (focusedDate.month == 10 && focusedDate.year == 2025) {
      print('October 2025 Debug:');
      print('First day of month: $firstDayOfMonth');
      print('DateTime.weekday: ${firstDayOfMonth.weekday}');
      print('Calculated firstWeekday: $firstWeekday');
      print('Last day: ${lastDayOfMonth.day}');
    }
    
    final List<Widget> dayWidgets = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container(
        height: 48,
        margin: const EdgeInsets.all(2),
        // Empty cell for previous month days
      ));
    }
    
    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      final hasEvents = events[_getDateOnly(date)]?.isNotEmpty == true;
      final isSelected = _isSameDay(date, selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      
      // Debug print for October days 1-5
      if (focusedDate.month == 10 && day <= 5) {
        print('October $day - hasEvents: $hasEvents, isSelected: $isSelected, isToday: $isToday');
        print('Event data for $date: ${events[_getDateOnly(date)]}');
      }
      
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            height: 48,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isToday
                      ? const Color(0xFF2563EB).withValues(alpha: 0.3) // More visible background
                      : hasEvents
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                          : null,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(
                      color: const Color(0xFF2563EB), // Direct color reference
                      width: isSelected ? 2 : 4, // Thicker border for today
                    )
                  : hasEvents && !isSelected
                      ? Border.all(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                          width: 1,
                        )
                      : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: isToday && !isSelected
                        ? BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? Colors.white // White text on blue background
                                  : hasEvents
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isToday ? FontWeight.w900 : hasEvents ? FontWeight.bold : FontWeight.normal,
                          fontSize: isToday ? 18 : 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasEvents && !isSelected && !isToday)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildEventCard(TrainingEvent event) {
    final theme = Theme.of(context);
    final isCompleted = event.status == 'Completed';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: event.color.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getEventIcon(event.title),
              color: event.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isCompleted 
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.schedule,
                  size: 14,
                  color: isCompleted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  event.status,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String title) {
    if (title.toLowerCase().contains('cardio') || title.toLowerCase().contains('run')) {
      return Icons.directions_run;
    } else if (title.toLowerCase().contains('strength')) {
      return Icons.fitness_center;
    } else if (title.toLowerCase().contains('recovery')) {
      return Icons.spa;
    } else if (title.toLowerCase().contains('hiit')) {
      return Icons.flash_on;
    } else if (title.toLowerCase().contains('flexibility')) {
      return Icons.self_improvement;
    }
    return Icons.event;
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Training Event'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Feature coming soon!'),
            SizedBox(height: 16),
            Text(
              'You will be able to add custom training events to your calendar.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  DateTime _getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class TrainingEvent {
  final String title;
  final String time;
  final String status;
  final Color color;

  TrainingEvent(this.title, this.time, this.status, this.color);
}