class CreateWorkerRequestDto {
  const CreateWorkerRequestDto({
    required this.fullName,
    required this.dailyWage,
    this.isActive = true,
  });

  final String fullName;
  final double dailyWage;
  final bool isActive;

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'daily_wage': dailyWage,
    'is_active': isActive,
  };
}

class UpdateWorkerRequestDto {
  const UpdateWorkerRequestDto({
    this.fullName,
    this.dailyWage,
    this.isActive,
  });

  final String? fullName;
  final double? dailyWage;
  final bool? isActive;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (dailyWage != null) data['daily_wage'] = dailyWage;
    if (isActive != null) data['is_active'] = isActive;
    return data;
  }
}
