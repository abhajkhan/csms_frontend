import 'package:flutter/material.dart';
import '../../models/worker.dart';
import 'worker_card.dart';

class WorkerCardList extends StatelessWidget {
  const WorkerCardList({
    super.key,
    required this.workers,
    required this.onViewDetails,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final List<Worker> workers;
  final ValueChanged<Worker> onViewDetails;
  final ValueChanged<Worker> onEdit;
  final ValueChanged<Worker> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final worker = workers[index];
        return WorkerCard(
          worker: worker,
          onTap: () => onViewDetails(worker),
          onEdit: () => onEdit(worker),
          onToggleStatus: () => onToggleStatus(worker),
        );
      },
    );
  }
}
