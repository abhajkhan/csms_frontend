class SiteSupervisorModel {
  const SiteSupervisorModel({
    required this.id,
    required this.siteId,
    required this.supervisorId,
    required this.assignedAt,
    required this.isActive,
    this.supervisorName,
    this.supervisorPhone,
  });

  final int id;
  final int siteId;
  final int supervisorId;
  final DateTime assignedAt;
  final bool isActive;
  final String? supervisorName;
  final String? supervisorPhone;

  String get formattedAssignedDate {
    return '${assignedAt.year}-${assignedAt.month.toString().padLeft(2, '0')}-${assignedAt.day.toString().padLeft(2, '0')}';
  }

  SiteSupervisorModel copyWith({
    int? id,
    int? siteId,
    int? supervisorId,
    DateTime? assignedAt,
    bool? isActive,
    String? supervisorName,
    String? supervisorPhone,
  }) =>
      SiteSupervisorModel(
        id: id ?? this.id,
        siteId: siteId ?? this.siteId,
        supervisorId: supervisorId ?? this.supervisorId,
        assignedAt: assignedAt ?? this.assignedAt,
        isActive: isActive ?? this.isActive,
        supervisorName: supervisorName ?? this.supervisorName,
        supervisorPhone: supervisorPhone ?? this.supervisorPhone,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteSupervisorModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          siteId == other.siteId &&
          supervisorId == other.supervisorId &&
          assignedAt == other.assignedAt &&
          isActive == other.isActive &&
          supervisorName == other.supervisorName &&
          supervisorPhone == other.supervisorPhone;

  @override
  int get hashCode =>
      id.hashCode ^
      siteId.hashCode ^
      supervisorId.hashCode ^
      assignedAt.hashCode ^
      isActive.hashCode ^
      supervisorName.hashCode ^
      supervisorPhone.hashCode;
}
