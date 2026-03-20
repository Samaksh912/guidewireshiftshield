import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';
import '../models.dart';
import '../widgets/widgets.dart';
import 'premium_summary_screen.dart';

// ─── S1: Welcome Screen ───────────────────────────────────────────────────────
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const ShieldIcon(size: 56, color: AppTheme.teal),
              const SizedBox(height: 28),
              Text(
                'Shift\nShield',
                style: AppText.display.copyWith(color: Colors.white, fontSize: 44, height: 1.1),
              ),
              const SizedBox(height: 12),
              Text(
                'Income protection for every shift.\nAutomatic. Fair. Instant.',
                style: AppText.body.copyWith(color: Colors.white54, fontSize: 16, height: 1.6),
              ),
              const Spacer(),
              // 3 value props
              _ValueProp(icon: Icons.calendar_today_outlined, text: 'Weekly coverage, priced per shift'),
              const SizedBox(height: 16),
              _ValueProp(icon: Icons.bolt_outlined, text: 'Zero claims — payouts are automatic'),
              const SizedBox(height: 16),
              _ValueProp(icon: Icons.account_balance_wallet_outlined, text: 'Directly to your UPI, within minutes'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Get started', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Already have an account? Sign in',
                    style: AppText.bodySmall.copyWith(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueProp extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ValueProp({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.teal.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.teal, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: AppText.body.copyWith(color: Colors.white70, fontSize: 14))),
      ],
    );
  }
}

// ─── S2: Registration Screen ──────────────────────────────────────────────────
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  String _platform = 'Swiggy';
  String _city = 'Bengaluru';
  int _earnings = 800;
  bool _showOtp = false;
  final _otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tell us about yourself', style: AppText.h1),
              const SizedBox(height: 4),
              Text('Used to set up your income protection profile', style: AppText.body),
              const SizedBox(height: 28),

              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
              ),
              const SizedBox(height: 14),

              // Mobile + OTP
              TextFormField(
                controller: _mobileCtrl,
                decoration: InputDecoration(
                  labelText: 'Mobile number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  prefixText: '+91  ',
                  suffixIcon: TextButton(
                    onPressed: () => setState(() => _showOtp = true),
                    child: const Text('Send OTP', style: TextStyle(color: AppTheme.teal, fontFamily: 'Nunito', fontWeight: FontWeight.w700)),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                validator: (v) => (v == null || v.length != 10) ? 'Enter valid 10-digit number' : null,
              ),

              if (_showOtp) ...[
                const SizedBox(height: 14),
                TextFormField(
                  controller: _otpCtrl,
                  decoration: const InputDecoration(labelText: 'Enter OTP', prefixIcon: Icon(Icons.lock_outline)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                ),
                const SizedBox(height: 4),
                Text('For demo, enter any 6-digit number', style: AppText.bodySmall.copyWith(color: AppTheme.textHint)),
              ],

              const SizedBox(height: 20),
              const SectionHeader(title: 'Platform you work on'),
              const SizedBox(height: 10),
              Row(
                children: MockData.platforms.map((p) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: p == MockData.platforms.last ? 0 : 10),
                    child: _PlatformTile(
                      platform: p,
                      selected: _platform == p,
                      onTap: () => setState(() => _platform = p),
                    ),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 20),
              // City
              DropdownButtonFormField<String>(
                value: _city,
                decoration: const InputDecoration(labelText: 'City', prefixIcon: Icon(Icons.location_city_outlined)),
                items: MockData.cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Nunito')))).toList(),
                onChanged: (v) => setState(() => _city = v!),
              ),

              const SizedBox(height: 20),
              SectionHeader(title: 'Average daily earnings  —  ₹$_earnings'),
              const SizedBox(height: 4),
              Text('Used to calculate your payout amount. This becomes your income baseline.', style: AppText.bodySmall),
              Slider(
                value: _earnings.toDouble(),
                min: 200,
                max: 2000,
                divisions: 18,
                activeColor: AppTheme.teal,
                label: '₹$_earnings',
                onChanged: (v) => setState(() => _earnings = v.round()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹200', style: AppText.bodySmall),
                  Text('₹2,000', style: AppText.bodySmall),
                ],
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onContinue,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    final state = AppState();
    state.riderName = _nameCtrl.text.trim();
    state.mobile = _mobileCtrl.text.trim();
    state.platform = _platform;
    state.city = _city;
    state.dailyEarningsBaseline = _earnings;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ZoneSelectionScreen()));
  }
}

class _PlatformTile extends StatelessWidget {
  final String platform;
  final bool selected;
  final VoidCallback onTap;
  const _PlatformTile({required this.platform, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.teal.withOpacity(0.1) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppTheme.teal : AppTheme.border, width: selected ? 2 : 1),
        ),
        child: Center(
          child: Text(
            platform,
            style: AppText.h3.copyWith(color: selected ? AppTheme.teal : AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }
}

// ─── S3: Zone Selection ───────────────────────────────────────────────────────
class ZoneSelectionScreen extends StatefulWidget {
  const ZoneSelectionScreen({super.key});
  @override
  State<ZoneSelectionScreen> createState() => _ZoneSelectionScreenState();
}

class _ZoneSelectionScreenState extends State<ZoneSelectionScreen> {
  Zone? _selected;
  final state = AppState();

  List<Zone> get zones => MockData.zonesByCity[state.city] ?? MockData.bengaluruZones;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select your zone')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Where do you usually deliver?', style: AppText.h2),
                const SizedBox(height: 4),
                Text(
                  'Your zone determines your premium and is the area we monitor for disruptions.',
                  style: AppText.body,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: zones.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _ZoneTile(
                zone: zones[i],
                selected: _selected?.id == zones[i].id,
                onTap: () => setState(() => _selected = zones[i]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _selected == null
                  ? null
                  : () {
                state.selectedZone = _selected;
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ShiftSelectionScreen()));
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneTile extends StatelessWidget {
  final Zone zone;
  final bool selected;
  final VoidCallback onTap;
  const _ZoneTile({required this.zone, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.teal.withOpacity(0.07) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppTheme.teal : AppTheme.border, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected ? AppTheme.teal.withOpacity(0.15) : AppTheme.bgPage,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.location_on_outlined, color: selected ? AppTheme.teal : AppTheme.textSecondary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(zone.name, style: AppText.h3),
                  const SizedBox(height: 2),
                  Text('PIN ${zone.pinCode} · ${zone.city}', style: AppText.bodySmall),
                ],
              ),
            ),
            StatusBadge.risk(zone.riskLevel),
          ],
        ),
      ),
    );
  }
}

// ─── S4: Shift Selection ──────────────────────────────────────────────────────
class ShiftSelectionScreen extends StatefulWidget {
  const ShiftSelectionScreen({super.key});
  @override
  State<ShiftSelectionScreen> createState() => _ShiftSelectionScreenState();
}

class _ShiftSelectionScreenState extends State<ShiftSelectionScreen> {
  final state = AppState();

  @override
  Widget build(BuildContext context) {
    final premium = state.weeklyPremium;

    return Scaffold(
      appBar: AppBar(title: const Text('Select shifts to cover')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Which shifts do you work?', style: AppText.h2),
            const SizedBox(height: 4),
            Text('You can cover one or both. Dinner earns more — and costs slightly more.', style: AppText.body),
            const SizedBox(height: 24),

            _ShiftCard(
              shift: MockData.lunchShift,
              selected: state.lunchSelected,
              onTap: () => setState(() => state.lunchSelected = !state.lunchSelected),
            ),
            const SizedBox(height: 12),
            _ShiftCard(
              shift: MockData.dinnerShift,
              selected: state.dinnerSelected,
              onTap: () => setState(() => state.dinnerSelected = !state.dinnerSelected),
            ),

            const Spacer(),

            // Live premium preview
            SSCard(
              color: AppTheme.navy,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated weekly premium', style: AppText.bodySmall.copyWith(color: Colors.white54)),
                      const SizedBox(height: 4),
                      Text(
                        premium == 0 ? '—' : '₹$premium / week',
                        style: AppText.amountSmall.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const ShieldIcon(size: 40, color: AppTheme.teal),
                ],
              ),
            ),

            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: (!state.lunchSelected && !state.dinnerSelected)
                  ? null
                  : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumSummaryScreen())),
              child: const Text('See full quote'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShiftCard extends StatelessWidget {
  final ShiftType shift;
  final bool selected;
  final VoidCallback onTap;
  const _ShiftCard({required this.shift, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppTheme.teal.withOpacity(0.07) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppTheme.teal : AppTheme.border, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(shift.name, style: AppText.h2),
                      if (shift.isPeak) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                          child: Text('Peak earning window', style: AppText.bodySmall.copyWith(color: const Color(0xFF92400E), fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(shift.hours, style: AppText.body),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? AppTheme.teal : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: selected ? AppTheme.teal : AppTheme.border, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}