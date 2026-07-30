import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/ngo_profile_model.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/certificate_model.dart';
import '../../../core/models/profile_model.dart';
import '../../auth/data/auth_repository.dart';
import '../../../services/supabase_service.dart';

final ngoRepositoryProvider = Provider<NgoRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not logged in');
  }
  return NgoRepository(SupabaseService.client, user.id);
});

class NgoRepository {
  final SupabaseClient _client;
  final String _userId;

  NgoRepository(this._client, this._userId);

  // --- NGO PROFILE ---
  Future<NgoProfileModel?> getNgoProfile() async {
    final response = await _client
        .from('ngo_profiles')
        .select()
        .eq('profile_id', _userId)
        .maybeSingle();
    
    if (response == null) return null;
    return NgoProfileModel.fromJson(response);
  }

  Future<void> updateNgoProfile(Map<String, dynamic> updates) async {
    await _client.from('ngo_profiles').upsert({
      'profile_id': _userId,
      ...updates,
    });
  }

  // --- TASKS ---
  Future<List<TaskModel>> getMyTasks() async {
    final response = await _client
        .from('tasks')
        .select()
        .eq('ngo_id', _userId)
        .order('created_at', ascending: false);
    
    return (response as List).map((t) => TaskModel.fromJson(t)).toList();
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    await _client.from('tasks').insert({
      ...taskData,
      'ngo_id': _userId,
      // For simplicity, we just use the user's name as ngo_name if not joined
      // In a real app we might fetch it from ngo_profiles first.
    });
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updates) async {
    await _client.from('tasks').update(updates).eq('id', taskId).eq('ngo_id', _userId);
  }

  Future<void> deleteTask(String taskId) async {
    await _client.from('tasks').delete().eq('id', taskId).eq('ngo_id', _userId);
  }

  // --- APPLICATIONS ---
  Future<List<ApplicationModel>> getApplicationsForMyTasks() async {
    // To get applications for tasks created by this NGO, we need to join
    final response = await _client
        .from('applications')
        .select('*, tasks!inner(*)')
        .eq('tasks.ngo_id', _userId)
        .order('applied_at', ascending: false);
    
    return (response as List).map((a) => ApplicationModel.fromJson(a)).toList();
  }

  Future<void> updateApplicationStatus(String applicationId, String status, String applicantId, String taskTitle) async {
    await _client.from('applications').update({'status': status}).eq('id', applicationId);
    
    // Create a notification for the volunteer
    await sendNotification(
      userId: applicantId,
      type: 'APPLICATION_UPDATE',
      title: 'Application $status',
      body: 'Your application for "$taskTitle" has been $status.',
    );
  }

  // --- VOLUNTEERS ---
  // Fetch profiles of users who have applied to this NGO's tasks
  Future<List<ProfileModel>> getMyVolunteers() async {
    final response = await _client
        .from('applications')
        .select('applicant_id, profiles!inner(*), tasks!inner(ngo_id)')
        .eq('tasks.ngo_id', _userId)
        .eq('status', 'Accepted');
    
    // De-duplicate volunteers
    final Map<String, ProfileModel> uniqueVolunteers = {};
    for (var row in (response as List)) {
      if (row['profiles'] != null) {
        final profile = ProfileModel.fromJson(row['profiles']);
        uniqueVolunteers[profile.id] = profile;
      }
    }
    return uniqueVolunteers.values.toList();
  }

  // --- CERTIFICATES ---
  Future<void> issueCertificate(String volunteerId, String taskId, String title) async {
    await _client.from('certificates').insert({
      'user_id': volunteerId,
      'task_id': taskId,
      'title': title,
      'issued_by': _userId,
      'issue_date': DateTime.now().toIso8601String(),
    });

    await sendNotification(
      userId: volunteerId,
      type: 'CERTIFICATE',
      title: 'New Certificate Earned!',
      body: 'You have been awarded the certificate: $title',
    );
  }

  // --- NOTIFICATIONS ---
  Future<void> sendNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
  }) async {
    await _client.from('notifications').insert({
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
