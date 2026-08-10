class SiteSupervisorRequestDto {
  const SiteSupervisorRequestDto({
    required this.siteId,
    required this.supervisorId,
  });

  final int siteId;
  final int supervisorId;

  Map<String, dynamic> toJson() => {
    'site_id': siteId,
    'supervisor_id': supervisorId,
  };
}

class SiteSupervisorResponseDto {
  const SiteSupervisorResponseDto({
    required this.id,
    required this.siteId,
    required this.supervisorId,
    required this.assignedAt,
    required this.isActive,
    this.supervisorName,
    this.supervisorPhone,
  });

  factory SiteSupervisorResponseDto.fromJson(Map<String, dynamic> json) {
    final rawAssigned = json['assigned_at'] ?? json['assignedAt'];
    DateTime date;
    if (rawAssigned is String) {
      date = DateTime.tryParse(rawAssigned) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return SiteSupervisorResponseDto(
      id: (json['id'] ?? 0) as int,
      siteId: (json['site_id'] ?? json['siteId'] ?? 0) as int,
      supervisorId: (json['supervisor_id'] ?? json['supervisorId'] ?? 0) as int,
      assignedAt: date,
      isActive: (json['is_active'] ?? json['isActive'] ?? true) as bool,
      supervisorName: (json['supervisor_name'] ?? json['supervisorName']) as String?,
      supervisorPhone: (json['supervisor_phone'] ?? json['supervisorPhone']) as String?,
    );
  }

  final int id;
  final int siteId;
  final int supervisorId;
  final DateTime assignedAt;
  final bool isActive;
  final String? supervisorName;
  final String? supervisorPhone;

  Map<String, dynamic> toJson() => {
    'id': id,
    'site_id': siteId,
    'supervisor_id': supervisorId,
    'assigned_at': assignedAt.toIso8601String(),
    'is_active': isActive,
    if (supervisorName != null) 'supervisor_name': supervisorName,
    if (supervisorPhone != null) 'supervisor_phone': supervisorPhone,
  };
}
