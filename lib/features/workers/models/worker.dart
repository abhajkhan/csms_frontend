class Worker {
  const Worker({
    required this.id,
    required this.fullName,
    required this.dailyWage,
    this.isActive = true,
    this.createdBy,
    // TODO(api): The following optional fields are present in preliminary UI specifications
    // but not defined in the backend DB schema/payloads (§6.4 in CSMS_Backend_SPEC.md).
    this.phone,
    this.address,
    this.skill,
    this.assignedSite,
  });

  final int id;
  final String fullName;
  final double dailyWage;
  final bool isActive;
  final int? createdBy;

  // TODO(api): Reserved for future backend integration if schema is expanded.
  final String? phone;
  final String? address;
  final String? skill;
  final String? assignedSite;

  String get formattedWage => '₹${dailyWage.toStringAsFixed(2)}';

  String get statusLabel => isActive ? 'Active' : 'Inactive';

  Worker copyWith({
    int? id,
    String? fullName,
    double? dailyWage,
    bool? isActive,
    int? createdBy,
    String? phone,
    String? address,
    String? skill,
    String? assignedSite,
  }) => Worker(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    dailyWage: dailyWage ?? this.dailyWage,
    isActive: isActive ?? this.isActive,
    createdBy: createdBy ?? this.createdBy,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    skill: skill ?? this.skill,
    assignedSite: assignedSite ?? this.assignedSite,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Worker &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          dailyWage == other.dailyWage &&
          isActive == other.isActive &&
          createdBy == other.createdBy &&
          phone == other.phone &&
          address == other.address &&
          skill == other.skill &&
          assignedSite == other.assignedSite;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      dailyWage.hashCode ^
      isActive.hashCode ^
      createdBy.hashCode ^
      phone.hashCode ^
      address.hashCode ^
      skill.hashCode ^
      assignedSite.hashCode;
}
