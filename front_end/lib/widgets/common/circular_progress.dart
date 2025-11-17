import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

class CircularProgress extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final List<Color> gradientColors;
  final String centerText;
  final String? label;
  final bool animate;

  const CircularProgress({
    Key? key,
    required this.value,
    this.size = 120,
    this.strokeWidth = 12,
    this.gradientColors = const [AppColors.pinkPrimary, AppColors.purplePrimary],
    required this.centerText,
    this.label,
    this.animate = true,
  }) : super(key: key);

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animate ? const Duration(milliseconds: 1000) : Duration.zero,
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: CircularProgressPainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  gradientColors: widget.gradientColors,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.centerText,
                        style: widget.size > 100
                            ? AppTextStyles.vitalValue.copyWith(
                                fontSize: widget.size * 0.25,
                              )
                            : AppTextStyles.vitalValueMedium.copyWith(
                                fontSize: widget.size * 0.25,
                              ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.label != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.label!.toUpperCase(),
                          style: AppTextStyles.vitalLabel.copyWith(
                            fontSize: widget.size * 0.08,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = AppColors.darkGray
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc with gradient
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        colors: gradientColors,
        startAngle: 0.0,
        endAngle: math.pi * 2,
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
