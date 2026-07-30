import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'volunteer_repository.dart';
import '../../../core/models/profile_model.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/certificate_model.dart';

final volunteerRepositoryProvider = Provider<VolunteerRepository>((ref) {
  return VolunteerRepository(Supabase.instance.client);
});

final volunteerProfileProvider = FutureProvider.autoDispose<ProfileModel?>((ref) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getProfile();
});

final openOpportunitiesProvider = FutureProvider.autoDispose<List<TaskModel>>((ref) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getOpenOpportunities();
});

final taskDetailProvider = FutureProvider.family.autoDispose<TaskModel, String>((ref, taskId) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getTaskById(taskId);
});

final myApplicationsProvider = FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getMyApplications();
});

final myActiveTasksProvider = FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final applications = await ref.watch(myApplicationsProvider.future);
  // Assuming 'Accepted' is the status for active tasks
  return applications.where((app) => app.status == 'Accepted').toList();
});

final completedTasksProvider = FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final applications = await ref.watch(myApplicationsProvider.future);
  // Assuming 'Completed' is the status for completed tasks
  return applications.where((app) => app.status == 'Completed').toList();
});

final savedTasksProvider = FutureProvider.autoDispose<List<TaskModel>>((ref) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getSavedTasks();
});

final notificationsProvider = FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getNotifications();
});

final certificatesProvider = FutureProvider.autoDispose<List<CertificateModel>>((ref) async {
  final repo = ref.watch(volunteerRepositoryProvider);
  return await repo.getCertificates();
});
