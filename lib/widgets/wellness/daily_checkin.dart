import 'package:flutter/material.dart';

class DailyCheckInAssessment extends StatefulWidget {
  const DailyCheckInAssessment({super.key});

  @override
  State<DailyCheckInAssessment> createState() => _DailyCheckInAssessmentState();
}

class _DailyCheckInAssessmentState extends State<DailyCheckInAssessment> {
  int currentStep = 0;
  Map<String, dynamic> responses = {};
  
  final List<Map<String, dynamic>> questions = [
    {
      'title': 'How are you feeling overall today?',
      'type': 'mood',
      'key': 'overall_mood',
      'options': [
        {'emoji': '😫', 'label': 'Terrible', 'value': 1},
        {'emoji': '😔', 'label': 'Poor', 'value': 2},
        {'emoji': '😐', 'label': 'Okay', 'value': 3},
        {'emoji': '😊', 'label': 'Good', 'value': 4},
        {'emoji': '🤩', 'label': 'Excellent', 'value': 5},
      ],
    },
    {
      'title': 'How well did you sleep last night?',
      'type': 'scale',
      'key': 'sleep_quality',
      'min': 1,
      'max': 10,
      'labels': ['Very Poor', 'Excellent'],
    },
    {
      'title': 'What\'s your energy level right now?',
      'type': 'mood',
      'key': 'energy_level',
      'options': [
        {'emoji': '🔋', 'label': 'Drained', 'value': 1},
        {'emoji': '😴', 'label': 'Low', 'value': 2},
        {'emoji': '😊', 'label': 'Normal', 'value': 3},
        {'emoji': '💪', 'label': 'High', 'value': 4},
        {'emoji': '⚡', 'label': 'Supercharged', 'value': 5},
      ],
    },
    {
      'title': 'How stressed do you feel today?',
      'type': 'scale',
      'key': 'stress_level',
      'min': 1,
      'max': 10,
      'labels': ['Not at all', 'Extremely'],
    },
    {
      'title': 'Any physical discomfort or pain?',
      'type': 'multiple_choice',
      'key': 'physical_state',
      'options': [
        'No discomfort',
        'Muscle soreness',
        'Joint stiffness',
        'Headache',
        'Back pain',
        'Other minor issues',
      ],
    },
    {
      'title': 'How motivated are you for training today?',
      'type': 'mood',
      'key': 'motivation',
      'options': [
        {'emoji': '😑', 'label': 'Not at all', 'value': 1},
        {'emoji': '😕', 'label': 'Low', 'value': 2},
        {'emoji': '😐', 'label': 'Neutral', 'value': 3},
        {'emoji': '😄', 'label': 'High', 'value': 4},
        {'emoji': '🔥', 'label': 'Pumped!', 'value': 5},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Progress Indicator
            Row(
              children: [
                Text(
                  'Daily Assessment',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${currentStep + 1}/${questions.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Progress Bar
            LinearProgressIndicator(
              value: (currentStep + 1) / questions.length,
              backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
            
            const SizedBox(height: 32),
            
            // Question Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: _buildQuestionContent(context, questions[currentStep]),
              ),
            ),
            
            // Navigation Buttons
            Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },
                      child: const Text('Previous'),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _canProceed() ? _nextStep : null,
                    child: Text(
                      currentStep == questions.length - 1 ? 'Complete' : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(BuildContext context, Map<String, dynamic> question) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['title'],
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 24),
        
        if (question['type'] == 'mood')
          _buildMoodSelector(question),
        if (question['type'] == 'scale')
          _buildScaleSelector(question),
        if (question['type'] == 'multiple_choice')
          _buildMultipleChoice(question),
      ],
    );
  }

  Widget _buildMoodSelector(Map<String, dynamic> question) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: question['options'].map<Widget>((option) {
            final isSelected = responses[question['key']] == option['value'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  responses[question['key']] = option['value'];
                });
              },
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option['emoji'],
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option['label'],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScaleSelector(Map<String, dynamic> question) {
    final currentValue = responses[question['key']] ?? question['min'].toDouble();
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(question['labels'][0]),
            Text(question['labels'][1]),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Slider(
          value: currentValue.toDouble(),
          min: question['min'].toDouble(),
          max: question['max'].toDouble(),
          divisions: question['max'] - question['min'],
          label: currentValue.round().toString(),
          onChanged: (value) {
            setState(() {
              responses[question['key']] = value.round();
            });
          },
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Selected: ${currentValue.round()}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleChoice(Map<String, dynamic> question) {
    return Column(
      children: question['options'].map<Widget>((option) {
        final isSelected = responses[question['key']] == option;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                responses[question['key']] = option;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                      ? Theme.of(context).primaryColor 
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : null,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _canProceed() {
    return responses.containsKey(questions[currentStep]['key']);
  }
  
  void _nextStep() {
    if (currentStep < questions.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      _completeAssessment();
    }
  }
  
  void _completeAssessment() {
    // Calculate wellness score
    final wellnessScore = _calculateWellnessScore();
    final recommendation = _getRecommendation(wellnessScore);
    
    Navigator.pop(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your wellness score: ${wellnessScore.toInt()}/100'),
            const SizedBox(height: 12),
            Text(
              'Recommendation:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(recommendation),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
  
  double _calculateWellnessScore() {
    double totalScore = 0;
    int factors = 0;
    
    // Overall mood (0-20 points)
    if (responses['overall_mood'] != null) {
      totalScore += (responses['overall_mood'] / 5.0) * 20;
      factors++;
    }
    
    // Sleep quality (0-20 points)
    if (responses['sleep_quality'] != null) {
      totalScore += (responses['sleep_quality'] / 10.0) * 20;
      factors++;
    }
    
    // Energy level (0-20 points)
    if (responses['energy_level'] != null) {
      totalScore += (responses['energy_level'] / 5.0) * 20;
      factors++;
    }
    
    // Stress level (0-20 points, inverted)
    if (responses['stress_level'] != null) {
      totalScore += ((11 - responses['stress_level']) / 10.0) * 20;
      factors++;
    }
    
    // Motivation (0-20 points)
    if (responses['motivation'] != null) {
      totalScore += (responses['motivation'] / 5.0) * 20;
      factors++;
    }
    
    return factors > 0 ? totalScore / factors * 5 : 50;
  }
  
  String _getRecommendation(double score) {
    if (score >= 80) {
      return 'Excellent! You\'re in great shape. Consider a challenging workout today.';
    } else if (score >= 60) {
      return 'Good overall wellness. A moderate workout would be perfect today.';
    } else if (score >= 40) {
      return 'You\'re doing okay, but consider some light exercise and extra rest.';
    } else {
      return 'Take it easy today. Focus on rest, hydration, and gentle movement.';
    }
  }
}