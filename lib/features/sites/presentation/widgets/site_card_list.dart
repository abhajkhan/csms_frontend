import 'package:flutter/material.dart';
import '../../models/site_model.dart';
import 'site_card.dart';

class SiteCardList extends StatelessWidget {
  const SiteCardList({
    super.key,
    required this.sites,
    required this.onViewDetails,
    this.onEdit,
    this.onToggleStatus,
  });

  final List<SiteModel> sites;
  final ValueChanged<SiteModel> onViewDetails;
  final ValueChanged<SiteModel>? onEdit;
  final ValueChanged<SiteModel>? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sites.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final site = sites[index];
        return SiteCard(
          site: site,
          onViewDetails: () => onViewDetails(site),
          onEdit: onEdit != null ? () => onEdit!(site) : null,
          onToggleStatus: onToggleStatus != null
              ? (newStatus) => onToggleStatus!(site.copyWith(status: newStatus))
              : null,
        );
      },
    );
  }
}
