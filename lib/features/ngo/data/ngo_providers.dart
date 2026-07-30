import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ngo_repository.dart';
import '../../../core/models/ngo_profile_model.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/profile_model.dart';

final ngoProfileProvider = FutureProvider<NgoProfileModel?>((ref) async {
  final repo = ref.watch(ngoRepositoryProvider);
  return repo.getNgoProfile();
});

final ngoTasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repo = ref.watch(ngoRepositoryProvider);
  return repo.getMyTasks();
});

final ngoApplicationsProvider = FutureProvider<List<ApplicationModel>>((ref) async {
  final repo = ref.watch(ngoRepositoryProvider);
  return repo.getApplicationsForMyTasks();
});

final ngoVolunteersProvider = FutureProvider<List<ProfileModel>>((ref) async {
  final repo = ref.watch(ngoRepositoryProvider);
  return repo.getAllVolunteers();
});

final ngoFreelancersProvider = FutureProvider<List<ProfileModel>>((ref) async {
  final repo = ref.watch(ngoRepositoryProvider);
  return repo.getAllFreelancers();
});
