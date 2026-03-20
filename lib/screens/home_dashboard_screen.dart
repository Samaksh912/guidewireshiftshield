import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import '../models.dart';
import '../widgets/widgets.dart';

// ─── S9: Home Dashboard ────────────────────────────────────────────────────────
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});
  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _navIndex = 0;
  final state = AppState();

  final _pages = const [
    _HomeTab(),
    _PolicyTab(),
    _PayoutsTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_navIndex],
      bottomNavigationBar: SSBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ─── Home tab ─────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good evening,', style: AppText.bodySmall),
                      Text(state.riderName.isEmpty ? 'Rider' : state.riderName.split(' ').first, style: AppText.h1),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const ShieldIcon(size: 36, color: AppTheme.teal),
              ],
            ),
            const SizedBox(height: 20),

            // ── Policy status card ──
            state.hasPolicyThisWeek ? _ActivePolicyCard() : _NoPolicyCard(),

            const SizedBox(height: 20),

            // ── Live zone snapshot ──
            const SectionHeader(title: 'Zone snapshot'),
            const SizedBox(height: 10),
            SSCard(
              gradientBorder: true,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.teal, size: 18),
                      const SizedBox(width: 6),
                      Text(state.selectedZone?.name ?? 'No zone selected', style: AppText.h3),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppTheme.successLight, borderRadius: BorderRadius.circular(20)),
                        child: Text('Monitoring', style: AppText.bodySmall.copyWith(color: AppTheme.success, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: const [
                      _WeatherTile(icon: Icons.thermostat_outlined, label: 'Temp', value: '29°C'),
                      _WeatherTile(icon: Icons.water_drop_outlined, label: 'Rainfall', value: '0 mm'),
                      _WeatherTile(icon: Icons.air_outlined, label: 'AQI', value: '82'),
                      _WeatherTile(icon: Icons.traffic_outlined, label: 'Traffic', value: 'Normal'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Demo trigger ──
            const SectionHeader(title: 'Demo'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DisruptionAlertScreen())),
              icon: const Icon(Icons.warning_amber_rounded, size: 18),
              label: const Text('Simulate disruption alert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.amber,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            // ── Recent activity ──
            SectionHeader(
              title: 'Recent activity',
              trailing: 'View all',
              onTrailingTap: () {},
            ),
            const SizedBox(height: 10),
            ...AppState().payoutHistory.take(2).map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PayoutHistoryTile(event: e),
            )),
          ],
        ),
      ),
    );
  }
}

class _ActivePolicyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = AppState();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.navy, AppTheme.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.teal.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.teal, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Policy active', style: AppText.bodySmall.copyWith(color: AppTheme.teal, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              const ShieldIcon(size: 32, color: AppTheme.teal),
            ],
          ),
          const SizedBox(height: 16),
          Text('Income protected', style: AppText.bodySmall.copyWith(color: Colors.white38)),
          Text('Up to ₹${state.maxPayout}', style: AppText.amount.copyWith(color: Colors.white, fontSize: 32)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniInfo(label: 'Zone', value: state.selectedZone?.name ?? '—'),
              _MiniInfo(
                label: 'Shifts',
                value: [if (state.lunchSelected) 'Lunch', if (state.dinnerSelected) 'Dinner'].join('+'),
              ),
              _MiniInfo(label: 'Paid', value: '₹${state.weeklyPremium}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoPolicyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SSCard(
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppTheme.amber, size: 32),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'No active policy this week.\nBuy coverage before Saturday 11:59 PM.',
              style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: AppTheme.textPrimary, height: 1.4),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Buy now', style: TextStyle(fontFamily: 'Nunito', color: AppTheme.teal, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label;
  final String value;
  const _MiniInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.bodySmall.copyWith(color: Colors.white38, fontSize: 11)),
        Text(value, style: AppText.h3.copyWith(color: Colors.white)),
      ],
    );
  }
}

class _WeatherTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _WeatherTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(height: 4),
          Text(value, style: AppText.h3.copyWith(fontSize: 13)),
          Text(label, style: AppText.bodySmall),
        ],
      ),
    );
  }
}

// ─── Policy tab ───────────────────────────────────────────────────────────────
class _PolicyTab extends StatelessWidget {
  const _PolicyTab();

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My policy', style: AppText.h1),
            const SizedBox(height: 20),
            SSCard(
              color: AppTheme.navy,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShieldIcon(size: 32, color: AppTheme.teal),
                  const SizedBox(height: 12),
                  Text('Active this week', style: AppText.bodySmall.copyWith(color: Colors.white54)),
                  Text('₹${state.weeklyPremium} premium', style: AppText.amountSmall.copyWith(color: Colors.white)),
                  const SizedBox(height: 16),
                  _PolicyDetailRow('Zone', state.selectedZone?.name ?? '—'),
                  _PolicyDetailRow('Lunch shift', state.lunchSelected ? 'Covered (12PM–3PM)' : 'Not covered'),
                  _PolicyDetailRow('Dinner shift', state.dinnerSelected ? 'Covered (7PM–11PM)' : 'Not covered'),
                  _PolicyDetailRow('Max payout', '₹${state.maxPayout}'),
                  _PolicyDetailRow('Status', 'Active', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Coverage triggers'),
            const SizedBox(height: 10),
            SSCard(
              child: Column(
                children: const [
                  DisruptionSignalRow(label: 'Rainfall ≥ 15 mm/hr for 30 min', value: 'IMD API', confirmed: true),
                  DisruptionSignalRow(label: 'Temperature ≥ 42°C for 2+ hours', value: 'OpenWeatherMap', confirmed: true),
                  DisruptionSignalRow(label: 'AQI ≥ 301 for 60 minutes', value: 'OpenAQ', confirmed: true),
                  DisruptionSignalRow(label: 'Traffic density drop ≥ 40%', value: 'Maps API', confirmed: true),
                  DisruptionSignalRow(label: 'IMD Red / Orange alert', value: 'IMD Feed', confirmed: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _PolicyDetailRow(this.label, this.value, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Text(label, style: AppText.bodySmall.copyWith(color: Colors.white38)),
              const Spacer(),
              Text(value, style: AppText.h3.copyWith(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.white.withOpacity(0.08)),
      ],
    );
  }
}

// ─── Payouts tab ──────────────────────────────────────────────────────────────
class _PayoutsTab extends StatelessWidget {
  const _PayoutsTab();

  @override
  Widget build(BuildContext context) {
    final payouts = AppState().payoutHistory;
    final totalPaid = payouts.where((e) => e.status == PayoutStatus.paid).fold(0, (s, e) => s + e.amount);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payout history', style: AppText.h1),
                const SizedBox(height: 12),
                SSCard(
                  color: AppTheme.successLight,
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet, color: AppTheme.success, size: 28),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total received', style: AppText.bodySmall.copyWith(color: AppTheme.success)),
                          Text('₹$totalPaid', style: AppText.amountSmall.copyWith(color: AppTheme.success)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: payouts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _PayoutHistoryTile(event: payouts[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutHistoryTile extends StatelessWidget {
  final PayoutEvent event;
  const _PayoutHistoryTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return SSCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.water_drop_outlined, color: AppTheme.teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.disruptionType, style: AppText.h3.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text('${event.shiftName} · ${DateFormat('d MMM').format(event.date)}', style: AppText.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${event.amount}', style: AppText.h2.copyWith(color: AppTheme.success)),
              const SizedBox(height: 4),
              StatusBadge.payout(event.status),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Profile tab ──────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.teal.withOpacity(0.15),
                  child: Text(
                    state.riderName.isNotEmpty ? state.riderName[0].toUpperCase() : 'R',
                    style: AppText.h1.copyWith(color: AppTheme.teal),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.riderName.isEmpty ? 'Rider' : state.riderName, style: AppText.h2),
                      Text('${state.platform} partner · ${state.city}', style: AppText.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Account details'),
            const SizedBox(height: 10),
            SSCard(
              child: Column(
                children: [
                  InfoRow(label: 'Mobile', value: '+91 ${state.mobile.replaceRange(2, 8, '******')}'),
                  InfoRow(label: 'Platform', value: state.platform),
                  InfoRow(label: 'City', value: state.city),
                  InfoRow(label: 'Zone', value: state.selectedZone?.name ?? 'Not set'),
                  InfoRow(label: 'Daily baseline', value: '₹${state.dailyEarningsBaseline}', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Quick links'),
            const SizedBox(height: 10),
            _ProfileLink(icon: Icons.help_outline, label: 'How it works', onTap: () {}),
            const SizedBox(height: 8),
            _ProfileLink(icon: Icons.quiz_outlined, label: 'What counts as a disruption?', onTap: () {}),
            const SizedBox(height: 8),
            _ProfileLink(icon: Icons.notifications_outlined, label: 'Notification preferences', onTap: () {}),
            const SizedBox(height: 8),
            _ProfileLink(icon: Icons.admin_panel_settings_outlined, label: 'Admin dashboard (demo)', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
            }),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: () {}, child: const Text('Sign out')),
          ],
        ),
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileLink({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SSCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.teal),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppText.h3.copyWith(fontWeight: FontWeight.w600))),
          const Icon(Icons.chevron_right, size: 18, color: AppTheme.textHint),
        ],
      ),
    );
  }
}

// ─── S10: Disruption Alert ────────────────────────────────────────────────────
class DisruptionAlertScreen extends StatefulWidget {
  const DisruptionAlertScreen({super.key});
  @override
  State<DisruptionAlertScreen> createState() => _DisruptionAlertScreenState();
}

class _DisruptionAlertScreenState extends State<DisruptionAlertScreen> {
  bool _validating = true;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() { _validating = false; _confirmed = true; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: AppBar(title: const Text('Disruption detected')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.amber.withOpacity(0.5), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppTheme.amber, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Disruption detected', style: AppText.h2.copyWith(color: AppTheme.amber)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(state.disruptionType, style: AppText.h3),
                  const SizedBox(height: 4),
                  Text('Detected in ${state.selectedZone?.name ?? "your zone"} · ${state.disruptionShift} shift affected', style: AppText.bodySmall),
                  const SizedBox(height: 10),
                  Text('${TimeOfDay.now().format(context)} · ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: AppText.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Signal validation'),
            const SizedBox(height: 10),
            SSCard(
              child: Column(
                children: const [
                  DisruptionSignalRow(label: 'Rainfall: 18mm/hr (IMD confirmed)', value: '✓ Threshold met', confirmed: true),
                  DisruptionSignalRow(label: 'Traffic density: –52% vs 30-day avg', value: '✓ Threshold met', confirmed: true),
                  DisruptionSignalRow(label: 'Restaurant availability drop: –38%', value: '✓ Threshold met', confirmed: true),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SSCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppTheme.successLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.analytics_outlined, color: AppTheme.success, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Severity classification', style: AppText.h3),
                        Text(state.disruptionSeverity.label, style: AppText.bodySmall),
                      ],
                    ),
                  ),
                  Text(state.disruptionSeverity.percentage, style: AppText.amountSmall.copyWith(color: AppTheme.teal)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Income impact validation'),
            const SizedBox(height: 10),
            SSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_validating)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: AppTheme.teal, strokeWidth: 2),
                            SizedBox(height: 12),
                            Text('Validating income impact...', style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    AlertBanner(
                      title: 'Disruption confirmed',
                      subtitle: 'Both external signal and income impact validated. Payout initiated.',
                      color: AppTheme.success,
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                ],
              ),
            ),

            if (_confirmed) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutProcessingScreen())),
                icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                label: const Text('View payout details'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── S11: Payout Processing ───────────────────────────────────────────────────
class PayoutProcessingScreen extends StatefulWidget {
  const PayoutProcessingScreen({super.key});
  @override
  State<PayoutProcessingScreen> createState() => _PayoutProcessingScreenState();
}

class _PayoutProcessingScreenState extends State<PayoutProcessingScreen> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _runSteps();
  }

  Future<void> _runSteps() async {
    for (int i = 1; i <= 4; i++) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() => _step = i);
    }
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PayoutConfirmedScreen()));
  }

  StepState _stepState(int s) {
    if (_step > s) return StepState.complete;
    if (_step == s) return StepState.editing;
    return StepState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      appBar: AppBar(title: const Text('Processing payout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SSCard(
              color: AppTheme.navy,
              gradientBorder: true,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payout amount', style: AppText.bodySmall.copyWith(color: Colors.white38)),
                      Text('₹${state.disruptionPayout}', style: AppText.amountSmall.copyWith(color: AppTheme.teal)),
                      const SizedBox(height: 4),
                      Text(state.disruptionSeverity.label, style: AppText.bodySmall.copyWith(color: Colors.white54)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.send_to_mobile_outlined, color: AppTheme.teal, size: 32),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Processing steps', style: AppText.h2),
            const SizedBox(height: 20),
            PayoutStep(label: 'Disruption verified', state: _stepState(1)),
            PayoutStep(label: 'Policy coverage confirmed', state: _stepState(2)),
            PayoutStep(label: 'Fraud check passed', state: _stepState(3)),
            PayoutStep(label: 'Payout sent to UPI', state: _stepState(4), isLast: true),
          ],
        ),
      ),
    );
  }
}

// ─── S12: Payout Confirmed ────────────────────────────────────────────────────
class PayoutConfirmedScreen extends StatelessWidget {
  const PayoutConfirmedScreen({super.key});

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
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_outline, color: AppTheme.success, size: 64),
                ),
              ),
              const SizedBox(height: 24),
              Text('Payout sent!', style: AppText.display.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                '₹${state.disruptionPayout}',
                style: AppText.amount.copyWith(color: AppTheme.teal, fontSize: 52),
              ),
              Text('sent to your UPI', style: AppText.body.copyWith(color: Colors.white38)),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _ConfirmRow('UPI ID', '${state.mobile.substring(0, 2)}****@upi'),
                    _ConfirmRow('Disruption', state.disruptionType),
                    _ConfirmRow('Shift protected', state.disruptionShift),
                    _ConfirmRow('Severity', state.disruptionSeverity.label),
                    _ConfirmRow('Reference', 'SS${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}', isLast: true),
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
                child: const Text('Back to home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _ConfirmRow(this.label, this.value, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(label, style: AppText.bodySmall.copyWith(color: Colors.white38)),
              const Spacer(),
              Flexible(child: Text(value, style: AppText.h3.copyWith(color: Colors.white, fontSize: 13), textAlign: TextAlign.end)),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.white.withOpacity(0.08)),
      ],
    );
  }
}

// ─── Admin Dashboard ──────────────────────────────────────────────────────────
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operations overview', style: AppText.h2),
            const SizedBox(height: 4),
            Text('Phase 1 — simulated data', style: AppText.bodySmall),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: const [
                Expanded(child: _StatCard(label: 'Active policies', value: '1', icon: Icons.shield, color: AppTheme.teal)),
                SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Payouts this week', value: '₹320', icon: Icons.send, color: AppTheme.success)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: _StatCard(label: 'Fraud flags', value: '0', icon: Icons.flag_outlined, color: AppTheme.amber)),
                SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Active disruptions', value: '1', icon: Icons.warning_amber_outlined, color: AppTheme.danger)),
              ],
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Simulate disruption'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DisruptionAlertScreen())),
              icon: const Icon(Icons.flash_on_outlined, size: 18),
              label: const Text('Trigger rain event in Koramangala'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.amber,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Recent payout log'),
            const SizedBox(height: 10),
            ...AppState().payoutHistory.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SSCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${e.disruptionType} · ${e.shiftName}', style: AppText.h3.copyWith(fontSize: 13)),
                          Text(DateFormat('d MMM yyyy').format(e.date), style: AppText.bodySmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${e.amount}', style: AppText.h2.copyWith(color: AppTheme.success, fontSize: 16)),
                        const SizedBox(height: 4),
                        StatusBadge.payout(e.status),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return SSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value, style: AppText.amountSmall.copyWith(color: color, fontSize: 24)),
          const SizedBox(height: 2),
          Text(label, style: AppText.bodySmall),
        ],
      ),
    );
  }
}