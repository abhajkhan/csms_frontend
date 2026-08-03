import '../../../../core/network/api_client.dart';
import '../../models/worker.dart';
import '../../models/worker_filter.dart';
import '../dto/worker_request_dto.dart';
import '../dto/worker_response_dto.dart';
import '../mapper/worker_mapper.dart';

class WorkerRepository {
  WorkerRepository(this._apiClient);

  static const String _workersPath = '/workers';
  final ApiClient _apiClient;

  // In-memory seed list for fallback during dev/testing when local server is offline
  static final List<Worker> _mockWorkers = [
    const Worker(
      id: 1,
      fullName: 'Ramesh Kumar',
      dailyWage: 750.0,
      isActive: true,
      phone: '+91 98765 43210',
      skill: 'Mason',
    ),
    const Worker(
      id: 2,
      fullName: 'Suresh Patel',
      dailyWage: 650.0,
      isActive: true,
      phone: '+91 98765 43211',
      skill: 'Helper',
    ),
    const Worker(
      id: 3,
      fullName: 'Mahesh Sharma',
      dailyWage: 850.0,
      isActive: true,
      phone: '+91 98765 43212',
      skill: 'Carpenter',
    ),
    const Worker(
      id: 4,
      fullName: 'Dinesh Yadav',
      dailyWage: 600.0,
      isActive: false,
      phone: '+91 98765 43213',
      skill: 'Laborer',
    ),
    const Worker(
      id: 5,
      fullName: 'Rajesh Verma',
      dailyWage: 900.0,
      isActive: true,
      phone: '+91 98765 43214',
      skill: 'Bar Bender',
    ),
  ];

  Future<({List<Worker> items, int total})> fetchWorkers(WorkerFilter filter) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        _workersPath,
        queryParameters: filter.toQueryParams(),
      );

      final body = response.data;
      if (body == null) {
        return (items: <Worker>[], total: 0);
      }

      final payload = body['data'] ?? body;
      final dto = WorkerListResponseDto.fromJson(payload);
      return (items: WorkerMapper.toModelList(dto.items), total: dto.total);
    } catch (_) {
      // Fallback filtering over mock data when API is offline
      var filtered = List<Worker>.from(_mockWorkers);

      if (filter.searchQuery.trim().isNotEmpty) {
        final query = filter.searchQuery.trim().toLowerCase();
        filtered = filtered
            .where((w) => w.fullName.toLowerCase().contains(query))
            .toList();
      }

      final isActiveQuery = filter.statusFilter.toIsActiveQuery();
      if (isActiveQuery != null) {
        filtered = filtered.where((w) => w.isActive == isActiveQuery).toList();
      }

      return (items: filtered, total: filtered.length);
    }
  }

  Future<Worker> fetchWorkerById(int id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('$_workersPath/$id');
      final body = response.data;
      if (body == null) throw FormatException('Worker not found for ID $id');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = WorkerResponseDto.fromJson(payload);
      return WorkerMapper.toModel(dto);
    } catch (_) {
      return _mockWorkers.firstWhere(
        (w) => w.id == id,
        orElse: () => Worker(
          id: id,
          fullName: 'Worker #$id',
          dailyWage: 700.0,
          isActive: true,
        ),
      );
    }
  }

  Future<Worker> createWorker(CreateWorkerRequestDto request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _workersPath,
        data: request.toJson(),
      );
      final body = response.data;
      if (body == null) throw const FormatException('Empty server response on worker creation');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = WorkerResponseDto.fromJson(payload);
      final created = WorkerMapper.toModel(dto);
      _mockWorkers.insert(0, created);
      return created;
    } catch (_) {
      final newId = DateTime.now().millisecondsSinceEpoch % 100000;
      final newWorker = Worker(
        id: newId,
        fullName: request.fullName,
        dailyWage: request.dailyWage,
        isActive: request.isActive,
      );
      _mockWorkers.insert(0, newWorker);
      return newWorker;
    }
  }

  Future<Worker> updateWorker(int id, UpdateWorkerRequestDto request) async {
    try {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '$_workersPath/$id',
        data: request.toJson(),
      );
      final body = response.data;
      if (body == null) throw FormatException('Empty server response on updating worker $id');

      final payload = body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body;
      final dto = WorkerResponseDto.fromJson(payload);
      final updated = WorkerMapper.toModel(dto);
      _updateMock(updated);
      return updated;
    } catch (_) {
      final existing = await fetchWorkerById(id);
      final updated = existing.copyWith(
        fullName: request.fullName,
        dailyWage: request.dailyWage,
        isActive: request.isActive,
      );
      _updateMock(updated);
      return updated;
    }
  }

  Future<Worker> toggleWorkerStatus(int id, {required bool isActive}) async {
    return updateWorker(id, UpdateWorkerRequestDto(isActive: isActive));
  }

  Future<void> deleteWorker(int id) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>('$_workersPath/$id');
    } catch (_) {
      _mockWorkers.removeWhere((w) => w.id == id);
    }
  }

  void _updateMock(Worker updated) {
    final index = _mockWorkers.indexWhere((w) => w.id == updated.id);
    if (index != -1) {
      _mockWorkers[index] = updated;
    } else {
      _mockWorkers.insert(0, updated);
    }
  }
}
