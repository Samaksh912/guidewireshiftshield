import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';
import '../widgets/widgets.dart';
import 'home_dashboard_screen.dart';

// ─── S5: Premium Summary ──────────────────────────────────────────────────────
class PremiumSummaryScreen extends StatelessWidget {
  const PremiumSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    final now = DateTime.now();
    // Next Monday
    final daysUntilMonday = (8 - now.weekday) % 7 == 0 ? 7 : (8 - now.weekday) % 7;
    final weekStart = now.add(Duration(days: daysUntilMonday));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(title: const Text('Your quote')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero premium card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const ShieldIcon(size: 36, color: AppTheme.teal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weekly premium', style: AppText.bodySmall.copyWith(color: Colors.white54)),
                            Text('ShiftShield Protection', style: AppText.h3.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '₹${state.weeklyPremium}',
                    style: AppText.amount.copyWith(color: AppTheme.teal, fontSize: 48),
                  ),
                  Text('per week', style: AppText.body.copyWith(color: Colors.white38)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_fmt(weekStart)} – ${_fmt(weekEnd)}',
                      style: AppText.bodySmall.copyWith(color: Colors.white70, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Breakdown
            const SectionHeader(title: 'Premium breakdown'),
            const SizedBox(height: 12),
            SSCard(
              child: Column(
                children: [
                  InfoRow(label: 'Base premium (${state.selectedZone?.name})', value: '₹${state.selectedZone?.baseWeeklyPremium ?? 0}'),
                  if (state.lunchSelected) InfoRow(label: 'Lunch shift', value: '₹10'),
                  if (state.dinnerSelected) InfoRow(label: 'Dinner shift (peak)', value: '₹${MockData.dinnerShift.premiumAddon}'),
                  InfoRow(label: 'Zone risk (${state.selectedZone?.riskLevel.label})', value: '', isLast: false),
                  const Divider(height: 1, color: AppTheme.border, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Text('Total weekly premium', style: AppText.h3),
                        const Spacer(),
                        Text('₹${state.weeklyPremium}', style: AppText.amountSmall.copyWith(color: AppTheme.teal)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'What is covered'),
            const SizedBox(height: 12),
            SSCard(
              child: Column(
                children: const [
                  _CoveredItem(icon: Icons.water_drop_outlined, text: 'Heavy rain or flooding (≥ 15 mm/hr)'),
                  _CoveredItem(icon: Icons.thermostat_outlined, text: 'Extreme heat (≥ 42°C for 2+ hours)'),
                  _CoveredItem(icon: Icons.air_outlined, text: 'Severe air pollution (AQI ≥ 301)'),
                  _CoveredItem(icon: Icons.block_outlined, text: 'Curfew or zone closure'),
                  _CoveredItem(icon: Icons.flood_outlined, text: 'IMD Red / Orange flood alert', isLast: true),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.dangerLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppTheme.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Not covered: health insurance, accidents, vehicle damage, or medical expenses.',
                      style: AppText.bodySmall.copyWith(color: const Color(0xFF991B1B)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Maximum payout this week'),
            const SizedBox(height: 12),
            SSCard(
              gradientBorder: true,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Up to ₹${state.maxPayout}', style: AppText.amountSmall.copyWith(color: AppTheme.success)),
                        const SizedBox(height: 4),
                        Text('80% of your ₹${state.dailyEarningsBaseline} daily baseline', style: AppText.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.success, size: 28),
                ],
              ),
            ),

            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PolicyConfirmationScreen())),
              child: const Text('Activate this week\'s coverage'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${_day(d.weekday)} ${d.day} ${_month(d.month)}';
  String _day(int w) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];
  String _month(int m) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];
}

class _CoveredItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;
  const _CoveredItem({required this.icon, required this.text, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppTheme.teal),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: AppText.body.copyWith(color: AppTheme.textPrimary))),
              const Icon(Icons.check_circle_outline, size: 18, color: AppTheme.success),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppTheme.border),
      ],
    );
  }
}

// ─── S6: Policy Confirmation ──────────────────────────────────────────────────
class PolicyConfirmationScreen extends StatefulWidget {
  const PolicyConfirmationScreen({super.key});
  @override
  State<PolicyConfirmationScreen> createState() => _PolicyConfirmationScreenState();
}

class _PolicyConfirmationScreenState extends State<PolicyConfirmationScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review and confirm', style: AppText.h1),
            const SizedBox(height: 4),
            Text('Check the details before paying.', style: AppText.body),
            const SizedBox(height: 24),

            SSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const ShieldIcon(size: 28, color: AppTheme.teal),
                      const SizedBox(width: 10),
                      Text('Coverage details', style: AppText.h3),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.successLight, borderRadius: BorderRadius.circular(20)),
                        child: Text('Ready to activate', style: AppText.bodySmall.copyWith(color: AppTheme.success, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppTheme.border),
                  InfoRow(label: 'Rider', value: state.riderName),
                  InfoRow(label: 'Platform', value: state.platform),
                  InfoRow(label: 'Zone', value: '${state.selectedZone?.name}, ${state.selectedZone?.pinCode}'),
                  InfoRow(
                    label: 'Shifts covered',
                    value: [
                      if (state.lunchSelected) 'Lunch',
                      if (state.dinnerSelected) 'Dinner',
                    ].join(' + '),
                  ),
                  InfoRow(label: 'Weekly premium', value: '₹${state.weeklyPremium}'),
                  InfoRow(label: 'Max payout', value: '₹${state.maxPayout}', isLast: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Consent checkbox
            GestureDetector(
              onTap: () => setState(() => _agreed = !_agreed),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _agreed ? AppTheme.successLight : AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _agreed ? AppTheme.success : AppTheme.border, width: _agreed ? 2 : 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _agreed ? AppTheme.success : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _agreed ? AppTheme.success : AppTheme.border, width: 2),
                      ),
                      child: _agreed ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'I understand this policy covers income loss only from verified external disruptions. It does not cover health insurance, accidents, vehicle damage, or medical expenses.',
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: AppTheme.textPrimary, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _agreed
                  ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockPaymentScreen()))
                  : null,
              child: const Text('Proceed to payment'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── S7: Mock Payment ─────────────────────────────────────────────────────────
class MockPaymentScreen extends StatefulWidget {
  const MockPaymentScreen({super.key});
  @override
  State<MockPaymentScreen> createState() => _MockPaymentScreenState();
}

class _MockPaymentScreenState extends State<MockPaymentScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      appBar: AppBar(title: const Text('Pay premium')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SSCard(
              color: AppTheme.bgPage,
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.teal, size: 28),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount to pay', style: AppText.bodySmall),
                      Text('₹${state.weeklyPremium}', style: AppText.amountSmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Pay via UPI', style: AppText.h2),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.teal, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_outlined, color: AppTheme.teal, size: 22),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UPI', style: AppText.h3),
                      Text('${state.mobile}@upi', style: AppText.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(color: AppTheme.teal, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.amberLight, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Color(0xFF92400E)),
                  const SizedBox(width: 8),
                  Text('Phase 1 demo — payment is simulated.', style: AppText.bodySmall.copyWith(color: const Color(0xFF92400E))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _loading ? null : _onPay,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Pay ₹${state.weeklyPremium}'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPay() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PolicyActiveScreen()),
          (route) => false,
    );
  }
}

// ─── S8: Policy Active ────────────────────────────────────────────────────────
class PolicyActiveScreen extends StatelessWidget {
  const PolicyActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated shield
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: const ShieldIcon(size: 100, color: AppTheme.teal),
              ),
              const SizedBox(height: 28),
              Text('Policy active!', style: AppText.display.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                'Your income is protected for this week.\nWe\'re monitoring your zone 24/7.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: Colors.white54, height: 1.6),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Column(
                  children: [
                    _ActiveRow('Zone monitored', state.selectedZone?.name ?? '—'),
                    _ActiveRow(
                      'Shifts covered',
                      [if (state.lunchSelected) 'Lunch', if (state.dinnerSelected) 'Dinner'].join(' + '),
                    ),
                    _ActiveRow('Max payout this week', '₹${state.maxPayout}'),
                    _ActiveRow('Premium paid', '₹${state.weeklyPremium}', isLast: true),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
                      (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Go to home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _ActiveRow(this.label, this.value, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(label, style: AppText.bodySmall.copyWith(color: Colors.white54)),
              const Spacer(),
              Text(value, style: AppText.h3.copyWith(color: Colors.white)),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.white.withOpacity(0.08)),
      ],
    );
  }
}