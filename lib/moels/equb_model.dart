class Equb {
  final String id;
  final String name;
  final double totalAmount;
  final double contributionPerUser;
  final String frequency;
  final String status;
  final int rounds;
  final String startDate;
  final String endDate;
  final String nextPayoutDate;

  Equb({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.contributionPerUser,
    required this.frequency,
    required this.status,
    required this.rounds,
    required this.startDate,
    required this.endDate,
    required this.nextPayoutDate,
  });

  // Factory constructor to create Equb from a JSON map
  factory Equb.fromJson(Map<String, dynamic> json) {
    return Equb(
      id: json['_id'],
      name: json['name'],
      totalAmount: json['totalAmount'].toDouble(),
      contributionPerUser: json['contributionPerUser'].toDouble(),
      frequency: json['frequency'],
      status: json['status'],
      rounds: json['rounds'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      nextPayoutDate: json['nextPayoutDate'],
    );
  }
}
