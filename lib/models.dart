// ─── Models ───────────────────────────────────────────────────────────────────

class Zone {
  final String id;
  final String name;
  final String pinCode;
  final String city;
  final RiskLevel riskLevel;
  final int baseWeeklyPremium;

  const Zone({
    required this.id,
    required this.name,
    required this.pinCode,
    required this.city,
    required this.riskLevel,
    required this.baseWeeklyPremium,
  });
}

enum RiskLevel { low, medium, high }

extension RiskLevelX on RiskLevel {
  String get label => ['Low', 'Medium', 'High'][index];
}

class ShiftType {
  final String id;
  final String name;
  final String hours;
  final int premiumAddon;
  final bool isPeak;

  const ShiftType({
    required this.id,
    required this.name,
    required this.hours,
    required this.premiumAddon,
    required this.isPeak,
  });
}

class Policy {
  final String id;
  final DateTime weekStart;
  final DateTime weekEnd;
  final Zone zone;
  final List<ShiftType> shifts;
  final int weeklyPremium;
  final int maxPayout;
  final PolicyStatus status;

  const Policy({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    required this.zone,
    required this.shifts,
    required this.weeklyPremium,
    required this.maxPayout,
    required this.status,
  });
}

enum PolicyStatus { active, expired, pending }

class PayoutEvent {
  final String id;
  final DateTime date;
  final String disruptionType;
  final String shiftName;
  final SeverityLevel severity;
  final int amount;
  final PayoutStatus status;

  const PayoutEvent({
    required this.id,
    required this.date,
    required this.disruptionType,
    required this.shiftName,
    required this.severity,
    required this.amount,
    required this.status,
  });
}

enum SeverityLevel { level1, level2, level3, level4 }

extension SeverityLevelX on SeverityLevel {
  String get label => ['Level 1 — Mild', 'Level 2 — Moderate', 'Level 3 — Severe', 'Level 4 — Extreme'][index];
  String get percentage => ['20%', '40%', '60%', '80%'][index];
}

enum PayoutStatus { paid, processing, flagged }

// ─── Mock data ────────────────────────────────────────────────────────────────

class MockData {
  static const List<Zone> bengaluruZones = [
    Zone(id: 'z1', name: 'Koramangala', pinCode: '560034', city: 'Bengaluru', riskLevel: RiskLevel.high, baseWeeklyPremium: 35),
    Zone(id: 'z2', name: 'Indiranagar', pinCode: '560038', city: 'Bengaluru', riskLevel: RiskLevel.medium, baseWeeklyPremium: 28),
    Zone(id: 'z3', name: 'Whitefield', pinCode: '560066', city: 'Bengaluru', riskLevel: RiskLevel.medium, baseWeeklyPremium: 26),
    Zone(id: 'z4', name: 'HSR Layout', pinCode: '560102', city: 'Bengaluru', riskLevel: RiskLevel.high, baseWeeklyPremium: 34),
    Zone(id: 'z5', name: 'Jayanagar', pinCode: '560041', city: 'Bengaluru', riskLevel: RiskLevel.low, baseWeeklyPremium: 18),
  ];

  static const List<Zone> mumbaiZones = [
    Zone(id: 'z6', name: 'Bandra West', pinCode: '400050', city: 'Mumbai', riskLevel: RiskLevel.high, baseWeeklyPremium: 38),
    Zone(id: 'z7', name: 'Andheri East', pinCode: '400069', city: 'Mumbai', riskLevel: RiskLevel.medium, baseWeeklyPremium: 30),
    Zone(id: 'z8', name: 'Dadar', pinCode: '400014', city: 'Mumbai', riskLevel: RiskLevel.high, baseWeeklyPremium: 36),
  ];

  static const List<Zone> delhiZones = [
    Zone(id: 'z9', name: 'Lajpat Nagar', pinCode: '110024', city: 'Delhi', riskLevel: RiskLevel.high, baseWeeklyPremium: 36),
    Zone(id: 'z10', name: 'Connaught Place', pinCode: '110001', city: 'Delhi', riskLevel: RiskLevel.medium, baseWeeklyPremium: 28),
    Zone(id: 'z11', name: 'Dwarka', pinCode: '110075', city: 'Delhi', riskLevel: RiskLevel.low, baseWeeklyPremium: 20),
  ];

  static Map<String, List<Zone>> get zonesByCity => {
    'Bengaluru': bengaluruZones,
    'Mumbai': mumbaiZones,
    'Delhi': delhiZones,
    'Chennai': [
      const Zone(id: 'z12', name: 'T. Nagar', pinCode: '600017', city: 'Chennai', riskLevel: RiskLevel.high, baseWeeklyPremium: 40),
      const Zone(id: 'z13', name: 'Anna Nagar', pinCode: '600040', city: 'Chennai', riskLevel: RiskLevel.medium, baseWeeklyPremium: 30),
    ],
  };

  static const ShiftType lunchShift = ShiftType(
    id: 'lunch', name: 'Lunch', hours: '12:00 PM – 3:00 PM', premiumAddon: 0, isPeak: false,
  );

  static const ShiftType dinnerShift = ShiftType(
    id: 'dinner', name: 'Dinner', hours: '7:00 PM – 11:00 PM', premiumAddon: 7, isPeak: true,
  );

  static final List<PayoutEvent> samplePayouts = [
    PayoutEvent(
      id: 'p1', date: DateTime.now().subtract(const Duration(days: 3)),
      disruptionType: 'Heavy rainfall', shiftName: 'Dinner',
      severity: SeverityLevel.level2, amount: 320, status: PayoutStatus.paid,
    ),
    PayoutEvent(
      id: 'p2', date: DateTime.now().subtract(const Duration(days: 10)),
      disruptionType: 'Severe AQI', shiftName: 'Lunch',
      severity: SeverityLevel.level1, amount: 140, status: PayoutStatus.paid,
    ),
    PayoutEvent(
      id: 'p3', date: DateTime.now().subtract(const Duration(days: 18)),
      disruptionType: 'Flooding — Red Alert', shiftName: 'Dinner',
      severity: SeverityLevel.level3, amount: 480, status: PayoutStatus.paid,
    ),
  ];

  static const List<String> cities = ['Bengaluru', 'Mumbai', 'Delhi', 'Chennai', 'Pune', 'Hyderabad'];

  static const List<String> platforms = ['Swiggy', 'Zomato'];
}

// ─── App state (simple in-memory store for Phase 1) ───────────────────────────

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Rider info
  String riderName = '';
  String mobile = '';
  String platform = '';
  String city = '';
  int dailyEarningsBaseline = 800;

  // Policy selections
  Zone? selectedZone;
  bool lunchSelected = false;
  bool dinnerSelected = true;

  // Computed
  int get weeklyPremium {
    if (selectedZone == null) return 0;
    int base = selectedZone!.baseWeeklyPremium;
    if (lunchSelected) base += 10;
    if (dinnerSelected) base += MockData.dinnerShift.premiumAddon;
    return base;
  }

  int get maxPayout {
    int pct = 80;
    return (dailyEarningsBaseline * pct / 100).round();
  }

  bool get hasPolicyThisWeek => selectedZone != null;

  List<PayoutEvent> payoutHistory = MockData.samplePayouts;

  // Disruption simulation
  bool disruptionActive = false;
  String disruptionType = 'Heavy rainfall — 18mm/hr detected';
  String disruptionShift = 'Dinner';
  SeverityLevel disruptionSeverity = SeverityLevel.level2;
  int get disruptionPayout => (dailyEarningsBaseline * 0.4).round();
}