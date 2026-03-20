import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';

// ─── ShieldIcon widget ─────────────────────────────────────────────────────────
class ShieldIcon extends StatelessWidget {
  final double size;
  final Color color;
  const ShieldIcon({super.key, this.size = 48, this.color = AppTheme.teal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ShieldPainter(color: color)),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final Color color;
  _ShieldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w / 2, 0);
    path.lineTo(w, h * 0.2);
    path.lineTo(w, h * 0.55);
    path.quadraticBezierTo(w, h * 0.85, w / 2, h);
    path.quadraticBezierTo(0, h * 0.85, 0, h * 0.55);
    path.lineTo(0, h * 0.2);
    path.close();
    canvas.drawPath(path, paint);

    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final checkPath = Path();
    checkPath.moveTo(w * 0.28, h * 0.52);
    checkPath.lineTo(w * 0.44, h * 0.66);
    checkPath.lineTo(w * 0.72, h * 0.38);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── SSCard ───────────────────────────────────────────────────────────────────
class SSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool gradientBorder;

  const SSCard({super.key, required this.child, this.padding, this.color, this.onTap, this.gradientBorder = false});

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: gradientBorder ? null : Border.all(color: AppTheme.border),
      ),
      child: child,
    );

    if (gradientBorder) {
      cardContent = Container(
        padding: const EdgeInsets.all(2), // border width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), // 16 + 2
          gradient: const LinearGradient(
            colors: [AppTheme.teal, AppTheme.amber],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: cardContent,
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(gradientBorder ? 18 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(gradientBorder ? 18 : 16),
        child: cardContent,
      ),
    );
  }
}

// ─── StatusBadge ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const StatusBadge({super.key, required this.label, required this.bg, required this.fg});

  factory StatusBadge.risk(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return StatusBadge(label: 'Low Risk', bg: AppTheme.successLight, fg: AppTheme.success);
      case RiskLevel.medium:
        return StatusBadge(label: 'Medium Risk', bg: AppTheme.amberLight, fg: const Color(0xFF92400E));
      case RiskLevel.high:
        return StatusBadge(label: 'High Risk', bg: AppTheme.dangerLight, fg: AppTheme.danger);
    }
  }

  factory StatusBadge.payout(PayoutStatus s) {
    switch (s) {
      case PayoutStatus.paid:
        return const StatusBadge(label: 'Paid', bg: Color(0xFFD1FAE5), fg: Color(0xFF065F46));
      case PayoutStatus.processing:
        return const StatusBadge(label: 'Processing', bg: Color(0xFFFFF3C4), fg: Color(0xFF92400E));
      case PayoutStatus.flagged:
        return const StatusBadge(label: 'Under Review', bg: Color(0xFFFEE2E2), fg: Color(0xFF991B1B));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: AppText.bodySmall.copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }
}

// ─── InfoRow ──────────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const InfoRow({super.key, required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Text(label, style: AppText.body),
              const Spacer(),
              Text(value, style: AppText.h3),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppTheme.border),
      ],
    );
  }
}

// ─── SectionHeader ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  const SectionHeader({super.key, required this.title, this.trailing, this.onTrailingTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title.toUpperCase(), style: AppText.label),
        const Spacer(),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(trailing!, style: AppText.bodySmall.copyWith(color: AppTheme.teal, fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }
}

// ─── NavBar ───────────────────────────────────────────────────────────────────
class SSBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SSBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.transparent,
        indicatorColor: AppTheme.teal.withOpacity(0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.shield_outlined), selectedIcon: Icon(Icons.shield), label: 'Policy'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Payouts'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── AlertBanner ─────────────────────────────────────────────────────────────
class AlertBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const AlertBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.h3.copyWith(color: color)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppText.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── DisruptionSignalRow ──────────────────────────────────────────────────────
class DisruptionSignalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool confirmed;

  const DisruptionSignalRow({
    super.key,
    required this.label,
    required this.value,
    required this.confirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: confirmed ? AppTheme.success : AppTheme.amber,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: AppText.body)),
          Text(
            value,
            style: AppText.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: confirmed ? AppTheme.success : AppTheme.amber,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PayoutStepIndicator ──────────────────────────────────────────────────────
class PayoutStep extends StatelessWidget {
  final String label;
  final StepState state;
  final bool isLast;

  const PayoutStep({super.key, required this.label, required this.state, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final Color c = state == StepState.complete
        ? AppTheme.success
        : state == StepState.editing
        ? AppTheme.teal
        : AppTheme.border;

    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.withOpacity(0.15),
                border: Border.all(color: c, width: 2),
              ),
              child: state == StepState.complete
                  ? const Icon(Icons.check, size: 14, color: AppTheme.success)
                  : state == StepState.editing
                  ? const Center(child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.teal)))
                  : null,
            ),
            if (!isLast)
              Container(width: 2, height: 32, color: c.withOpacity(0.3)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: AppText.body.copyWith(
                color: state == StepState.complete ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontWeight: state == StepState.complete ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}