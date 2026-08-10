import '../../models/site_model.dart';

class CreateSiteRequestDto {
  const CreateSiteRequestDto({
    required this.siteName,
    this.location,
  });

  final String siteName;
  final String? location;

  Map<String, dynamic> toJson() => {
    'site_name': siteName,
    if (location != null && location!.trim().isNotEmpty)
      'location': location!.trim(),
  };
}

class UpdateSiteRequestDto {
  const UpdateSiteRequestDto({
    this.siteName,
    this.location,
    this.status,
  });

  final String? siteName;
  final String? location;
  final SiteStatus? status;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (siteName != null) data['site_name'] = siteName;
    if (location != null) data['location'] = location;
    if (status != null) data['status'] = status!.value;
    return data;
  }
}
