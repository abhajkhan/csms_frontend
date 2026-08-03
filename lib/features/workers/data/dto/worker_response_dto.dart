class WorkerResponseDto {
  const WorkerResponseDto({
    required this.workerId,
    required this.fullName,
    required this.dailyWage,
    required this.isActive,
    this.createdBy,
    // TODO(api): Placeholders for optional UI metadata if added to backend spec in future.
    this.phone,
    this.address,
    this.skill,
    this.assignedSite,
  });

  factory WorkerResponseDto.fromJson(Map<String, dynamic> json) {
    final rawWage = json['daily_wage'] ?? json['dailyWage'] ?? 0;
    final wage = rawWage is num ? rawWage.toDouble() : double.tryParse(rawWage.toString()) ?? 0.0;

    return WorkerResponseDto(
      workerId: (json['worker_id'] ?? json['id'] ?? 0) as int,
      fullName: (json['full_name'] ?? json['fullName'] ?? json['name'] ?? '') as String,
      dailyWage: wage,
      isActive: (json['is_active'] ?? json['isActive'] ?? true) as bool,
      createdBy: (json['created_by'] ?? json['createdBy']) as int?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      skill: json['skill'] as String?,
      assignedSite: json['assigned_site'] ?? json['assignedSite'] as String?,
    );
  }

  final int workerId;
  final String fullName;
  final double dailyWage;
  final bool isActive;
  final int? createdBy;

  final String? phone;
  final String? address;
  final String? skill;
  final String? assignedSite;

  Map<String, dynamic> toJson() => {
    'worker_id': workerId,
    'full_name': fullName,
    'daily_wage': dailyWage,
    'is_active': isActive,
    if (createdBy != null) 'created_by': createdBy,
    if (phone != null) 'phone': phone,
    if (address != null) 'address': address,
    if (skill != null) 'skill': skill,
    if (assignedSite != null) 'assigned_site': assignedSite,
  };
}

class WorkerListResponseDto {
  const WorkerListResponseDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory WorkerListResponseDto.fromJson(dynamic json) {
    if (json is List) {
      final items = json
          .whereType<Map<String, dynamic>>()
          .map(WorkerResponseDto.fromJson)
          .toList();
      return WorkerListResponseDto(
        items: items,
        total: items.length,
        page: 1,
        pageSize: items.isEmpty ? 20 : items.length,
      );
    }

    if (json is Map<String, dynamic>) {
      final rawItems = json['items'] ?? json['data'] ?? json['workers'] ?? [];
      final List<WorkerResponseDto> items;
      if (rawItems is List) {
        items = rawItems
            .whereType<Map<String, dynamic>>()
            .map(WorkerResponseDto.fromJson)
            .toList();
      } else {
        items = [];
      }

      final total = (json['total'] ?? json['total_count'] ?? items.length) as int;
      final page = (json['page'] ?? 1) as int;
      final pageSize = (json['page_size'] ?? json['pageSize'] ?? 20) as int;

      return WorkerListResponseDto(
        items: items,
        total: total,
        page: page,
        pageSize: pageSize,
      );
    }

    return const WorkerListResponseDto(
      items: [],
      total: 0,
      page: 1,
      pageSize: 20,
    );
  }

  final List<WorkerResponseDto> items;
  final int total;
  final int page;
  final int pageSize;
}
