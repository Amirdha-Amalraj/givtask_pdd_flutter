import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'freelancer_repository.dart';
import '../../../core/models/profile_model.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';

final freelancerRepositoryProvider = Provider<FreelancerRepository>((ref) {
  return FreelancerRepository(Supabase.instance.client);
});

final freelancerProfileProvider = FutureProvider.autoDispose<ProfileModel?>((ref) async {
  final repo = ref.watch(freelancerRepositoryProvider);
  return await repo.getProfile();
});

final paidProjectsProvider = FutureProvider.autoDispose<List<TaskModel>>((ref) async {
  final repo = ref.watch(freelancerRepositoryProvider);
  return await repo.getPaidProjects();
});

final freelanceProjectDetailProvider = FutureProvider.family.autoDispose<TaskModel, String>((ref, taskId) async {
  final repo = ref.watch(freelancerRepositoryProvider);
  return await repo.getProjectById(taskId);
});

final myProposalsProvider = FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final repo = ref.watch(freelancerRepositoryProvider);
  return await repo.getMyProposals();
});

final freelancerActiveProjectsProvider = FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final proposals = await ref.watch(myProposalsProvider.future);
  return proposals.where((app) => app.status == 'accepted').toList();
});

final freelancerCompletedProjectsProvider = FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final proposals = await ref.watch(myProposalsProvider.future);
  return proposals.where((app) => app.status == 'completed').toList();
});

final freelancerEarningsProvider = FutureProvider.autoDispose<double>((ref) async {
  final completed = await ref.watch(freelancerCompletedProjectsProvider.future);
  double total = 0.0;
  for (var app in completed) {
    if (app.task != null && app.task!.budget != null) {
      total += app.task!.budget!;
    }
  }
  return total;
});
