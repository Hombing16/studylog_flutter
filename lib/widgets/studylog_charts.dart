import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Badge Logo Universitas Mulia untuk menggantikan kotak huruf 'S'
class CampusLogoBadge extends StatelessWidget {
  final double size;
  final double borderRadius;
  final double padding;

  const CampusLogoBadge({
    super.key,
    this.size = 40,
    this.borderRadius = 11,
    this.padding = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo_um.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Latar belakang foto gedung kampus transparan untuk halaman Login
class CampusWatermarkBackground extends StatelessWidget {
  final Widget child;
  final double overlayOpacity;

  const CampusWatermarkBackground({
    super.key,
    required this.child,
    this.overlayOpacity = 0.84,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/campus_bg.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: StudyLogColors.creamWarm.withOpacity(overlayOpacity),
          ),
        ),
        child,
      ],
    );
  }
}

/// Grafik Batang Beban SKS per Hari (Senin - Jumat) dengan garis bantu horizontal
class BebanSksBarChart extends StatelessWidget {
  final Map<String, int> sksPerHari;

  const BebanSksBarChart({super.key, required this.sksPerHari});

  @override
  Widget build(BuildContext context) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];
    final fullDays = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    final values = fullDays.map((d) => sksPerHari[d] ?? 0).toList();
    final maxVal = math.max(6, values.fold<int>(0, math.max));

    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          // Garis bantu horizontal di area batang
          Positioned(
            left: 4,
            right: 4,
            top: 24,
            bottom: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (_) => Container(
                  height: 1,
                  color: const Color(0xFFEDEDED),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(days.length, (i) {
              final val = values[i];
              final ratio = (val / maxVal).clamp(0.08, 1.0);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        val > 0 ? '$val' : '0',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: val > 0
                              ? StudyLogColors.textPrimary
                              : StudyLogColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            heightFactor: val == 0 ? 0.08 : ratio,
                            child: Container(
                              width: 34,
                              decoration: BoxDecoration(
                                color: val > 0
                                    ? StudyLogColors.orangeBright
                                    : StudyLogColors.orangeSoft,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                  bottom: Radius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[i],
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: StudyLogColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Grafik Garis Tren IPS 4 Semester Terakhir
class TrenIpsLineChart extends StatelessWidget {
  final List<double> ipsValues;
  final List<String> labels;

  const TrenIpsLineChart({
    super.key,
    required this.ipsValues,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 92),
              painter: _TrenIpsPainter(ipsValues: ipsValues),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(labels.length, (i) {
              return Column(
                children: [
                  Text(
                    ipsValues[i].toStringAsFixed(2).replaceAll('.', ','),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: StudyLogColors.orange,
                    ),
                  ),
                  Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 11,
                      color: StudyLogColors.textSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TrenIpsPainter extends CustomPainter {
  final List<double> ipsValues;

  _TrenIpsPainter({required this.ipsValues});

  @override
  void paint(Canvas canvas, Size size) {
    if (ipsValues.length < 2) return;

    const minIps = 3.20;
    const maxIps = 4.00;
    const horizontalPad = 18.0;
    const verticalPad = 12.0;

    final usableWidth = size.width - (horizontalPad * 2);
    final usableHeight = size.height - (verticalPad * 2);

    final gridPaint = Paint()
      ..color = StudyLogColors.borderSubtle
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 4),
      Offset(size.width, size.height - 4),
      gridPaint,
    );

    final points = <Offset>[];
    for (int i = 0; i < ipsValues.length; i++) {
      final t = i / (ipsValues.length - 1);
      final x = horizontalPad + (t * usableWidth);
      final normY = ((ipsValues[i] - minIps) / (maxIps - minIps)).clamp(0.0, 1.0);
      final y = verticalPad + ((1.0 - normY) * usableHeight);
      points.add(Offset(x, y));
    }

    final areaPath = Path()..moveTo(points.first.dx, size.height - 4);
    for (final p in points) {
      areaPath.lineTo(p.dx, p.dy);
    }
    areaPath.lineTo(points.last.dx, size.height - 4);
    areaPath.close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          StudyLogColors.orangeBright.withOpacity(0.22),
          StudyLogColors.orangeBright.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(areaPath, areaPaint);

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = StudyLogColors.orangeBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    final outerDot = Paint()..color = StudyLogColors.orangeBright;
    final innerDot = Paint()..color = Colors.white;
    for (final p in points) {
      canvas.drawCircle(p, 4.5, outerDot);
      canvas.drawCircle(p, 2.0, innerDot);
    }
  }

  @override
  bool shouldRepaint(covariant _TrenIpsPainter oldDelegate) =>
      oldDelegate.ipsValues != ipsValues;
}
