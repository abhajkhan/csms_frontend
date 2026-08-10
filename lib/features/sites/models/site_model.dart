enum SiteStatus {
  active,
  completed,
  onHold;

  factory SiteStatus.fromString(String? value) => switch (value?.toLowerCase()) {
    'completed' => SiteStatus.completed,
    'on_hold' || 'onhold' => SiteStatus.onHold,
    _ => SiteStatus.active,
  };

  String get value => switch (this) {
    SiteStatus.active => 'active',
    SiteStatus.completed => 'completed',
    SiteStatus.onHold => 'on_hold',
  };

  String get label => switch (this) {
    SiteStatus.active => 'Active',
    SiteStatus.completed => 'Completed',
    SiteStatus.onHold => 'On Hold',
  };
}

class SiteModel {
  const SiteModel({
    required this.id,
    required this.name,
    this.location,
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });

  final int id;
  final String name;
  final String? location;
  final SiteStatus status;
  final DateTime createdAt;
  final int createdBy;

  String get formattedDate {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  SiteModel copyWith({
    int? id,
    String? name,
    String? location,
    SiteStatus? status,
    DateTime? createdAt,
    int? createdBy,
  }) =>
      SiteModel(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          location == other.location &&
          status == other.status &&
          createdAt == other.createdAt &&
          createdBy == other.createdBy;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      location.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      createdBy.hashCode;
}
