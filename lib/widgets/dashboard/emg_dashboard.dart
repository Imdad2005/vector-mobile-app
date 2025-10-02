import 'package:flutter/material.dart';
import 'dart:math' as math;

/// EMG Dashboard widget that replicates the web app's real-time EMG monitoring
class EMGDashboard extends StatefulWidget {
  const EMGDashboard({super.key});

  @override
  State<EMGDashboard> createState() => _EMGDashboardState();
}

class _EMGDashboardState extends State<EMGDashboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _emgData = [];
  final List<double> _ecgData = [];
  int _currentHeartRate = 72;
  int _currentMuscleActivity = 73;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..repeat();
    
    // Generate initial data
    _generateData();
    
    // Add listener to update data continuously
    _animationController.addListener(() {
      if (mounted) {
        setState(() {
          _updateRealTimeData();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateData() {
    final random = math.Random();
    
    // Generate EMG data (muscle activity)
    _emgData.clear();
    for (int i = 0; i < 100; i++) {
      _emgData.add(random.nextDouble() * 0.8 + 0.1);
    }
    
    // Generate ECG data (heart rhythm)
    _ecgData.clear();
    for (int i = 0; i < 100; i++) {
      final heartbeat = math.sin(i * 0.3) * 0.8;
      final noise = (random.nextDouble() - 0.5) * 0.1;
      _ecgData.add((heartbeat + noise + 1) / 2);
    }
  }

  void _updateRealTimeData() {
    final random = math.Random();
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    
    // Shift existing data left and add new point for EMG
    if (_emgData.length >= 100) {
      _emgData.removeAt(0);
    }
    // Generate realistic EMG signal with some activity bursts
    final baseActivity = 0.2;
    final activityBurst = math.sin(time * 0.5) > 0.7 ? 0.6 : 0.0;
    final noise = (random.nextDouble() - 0.5) * 0.1;
    _emgData.add((baseActivity + activityBurst + noise).clamp(0.0, 1.0));
    
    // Shift existing data left and add new point for ECG
    if (_ecgData.length >= 100) {
      _ecgData.removeAt(0);
    }
    // Generate realistic ECG signal (heart rhythm)
    final heartRate = 72; // BPM
    final heartPhase = (time * heartRate / 60) % 1.0;
    double ecgValue = 0.5;
    
    if (heartPhase < 0.1) {
      // P wave
      ecgValue = 0.5 + math.sin(heartPhase * math.pi * 10) * 0.1;
    } else if (heartPhase > 0.2 && heartPhase < 0.4) {
      // QRS complex
      if (heartPhase < 0.3) {
        ecgValue = 0.5 - (heartPhase - 0.2) * 5; // Q wave
      } else {
        ecgValue = 0.5 + (heartPhase - 0.3) * 8; // R wave
      }
    } else if (heartPhase > 0.4 && heartPhase < 0.6) {
      // T wave
      ecgValue = 0.5 + math.sin((heartPhase - 0.4) * math.pi * 5) * 0.2;
    }
    
    final ecgNoise = (random.nextDouble() - 0.5) * 0.02;
    _ecgData.add((ecgValue + ecgNoise).clamp(0.0, 1.0));
    
    // Update real-time metrics occasionally
    if (random.nextDouble() < 0.1) { // 10% chance each frame
      _currentHeartRate = (70 + random.nextInt(10)).clamp(65, 85); // Realistic resting HR variation
      _currentMuscleActivity = (65 + random.nextInt(20)).clamp(50, 90); // Muscle activity variation
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Connection Status
          _buildConnectionStatus(context),
          
          const SizedBox(height: 16),
          
          // EMG Signal Chart
          _buildSignalChart(
            context,
            title: 'EMG Signal (Muscle Activity)',
            data: _emgData,
            color: Colors.green,
            unit: 'mV',
          ),
          
          const SizedBox(height: 16),
          
          // ECG Signal Chart
          _buildSignalChart(
            context,
            title: 'ECG Signal (Heart Rhythm)',
            data: _ecgData,
            color: Colors.red,
            unit: 'mV',
          ),
          
          const SizedBox(height: 16),
          
          // Real-time Metrics
          _buildRealTimeMetrics(context),
          
          const SizedBox(height: 16),
          
          // Control Buttons
          _buildControlButtons(context),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Vector Belt Connected',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
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
                'Live',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalChart(
    BuildContext context, {
    required String title,
    required List<double> data,
    required Color color,
    required String unit,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Signal visualization
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: SignalPainter(data, color),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTimeMetrics(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            context,
            title: 'Heart Rate',
            value: _currentHeartRate.toString(),
            unit: 'BPM',
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            context,
            title: 'Muscle Activity',
            value: _currentMuscleActivity.toString(),
            unit: '%',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
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

  Widget _buildControlButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _generateData();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recording started...')),
              );
            },
            icon: const Icon(Icons.fiber_manual_record),
            label: const Text('Record'),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for signal visualization
class SignalPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  
  SignalPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}