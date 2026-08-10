import '../../models/site_model.dart';

class SiteResponseDto {
  const SiteResponseDto({
    required this.siteId,
    required this.siteName,
    this.location,
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });

  factory SiteResponseDto.fromJson(Map<String, dynamic> json) {
    final rawCreated = json['created_at'] ?? json['createdAt'];
    DateTime date;
    if (rawCreated is String) {
      date = DateTime.tryParse(rawCreated) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return SiteResponseDto(
      siteId: (json['site_id'] ?? json['id'] ?? 0) as int,
      siteName: (json['site_name'] ?? json['siteName'] ?? json['name'] ?? '') as String,
      location: json['location'] as String?,
      status: SiteStatus.fromString(json['status'] as String?),
      createdAt: date,
      createdBy: (json['created_by'] ?? json['createdBy'] ?? 0) as int,
    );
  }

  final int siteId;
  final String siteName;
  final String? location;
  final SiteStatus status;
  final DateTime createdAt;
  final int createdBy;

  Map<String, dynamic> toJson() => {
    'site_id': siteId,
    'site_name': siteName,
    if (location != null) 'location': location,
    'status': status.value,
    'created_at': createdAt.toIso8601String(),
    'created_by': createdBy,
  };
}

class SiteListResponseDto {
  const SiteListResponseDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory SiteListResponseDto.fromJson(dynamic json) {
    if (json is List) {
      final items = json
          .whereType<Map<String, dynamic>>()
          .map(SiteResponseDto.fromJson)
          .toList();
      return SiteListResponseDto(
        items: items,
        total: items.length,
        page: 1,
        pageSize: items.isEmpty ? 20 : items.length,
        totalPages: 1,
      );
    }

    if (json is Map<String, dynamic>) {
      final rawItems = json['items'] ?? json['data'] ?? json['sites'] ?? [];
      final List<SiteResponseDto> items;
      if (rawItems is List) {
        items = rawItems
            .whereType<Map<String, dynamic>>()
            .map(SiteResponseDto.fromJson)
            .toList();
      } else {
        items = [];
      }

      final total = (json['total'] ?? items.length) as int;
      final page = (json['page'] ?? 1) as int;
      final pageSize = (json['page_size'] ?? json['pageSize'] ?? 20) as int;
      final totalPages = (json['total_pages'] ?? json['totalPages'] ?? 1) as int;

      return SiteListResponseDto(
        items: items,
        total: total,
        page: page,
        pageSize: pageSize,
        totalPages: totalPages,
      );
    }

    return const SiteListResponseDto(
      items: [],
      total: 0,
      page: 1,
      pageSize: 20,
      totalPages: 1,
    );
  }

  final List<SiteResponseDto> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
}
