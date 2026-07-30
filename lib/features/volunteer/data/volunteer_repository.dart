import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/profile_model.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/certificate_model.dart';

class VolunteerRepository {
  final SupabaseClient _client;

  VolunteerRepository(this._client);

  String? get currentUserId => _client.auth.currentUser?.id;

  // --- Profiles ---
  Future<ProfileModel?> getProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;
    
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
        
    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    
    await _client.from('profiles').update(updates).eq('id', userId);
  }

  // --- Tasks (Opportunities) ---
  Future<List<TaskModel>> getOpenOpportunities() async {
    final response = await _client
        .from('tasks')
        .select('*, profiles(ngo_profiles!ngo_profiles_profile_id_fkey(org_name))')
        .eq('status', 'open') // Assuming 'open' is a valid status
        .order('created_at', ascending: false);
        
    return response.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<TaskModel> getTaskById(String taskId) async {
    final response = await _client
        .from('tasks')
        .select('*, profiles(ngo_profiles!ngo_profiles_profile_id_fkey(org_name))')
        .eq('id', taskId)
        .single();
        
    return TaskModel.fromJson(response);
  }

  // --- Applications ---
  Future<List<ApplicationModel>> getMyApplications() async {
    final userId = currentUserId;
    if (userId == null) return [];
    
    final response = await _client
        .from('applications')
        .select('*, tasks(*)')
        .eq('applicant_id', userId)
        .order('applied_at', ascending: false);
        
    return response.map((e) => ApplicationModel.fromJson(e)).toList();
  }
  
  Future<void> applyForTask(String taskId, {String? coverNote}) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    
    await _client.from('applications').insert({
      'task_id': taskId,
      'applicant_id': userId,
      'cover_note': coverNote,
      'status': 'Pending',
    });
  }

  // --- Saved Tasks ---
  Future<List<TaskModel>> getSavedTasks() async {
    final userId = currentUserId;
    if (userId == null) return [];
    
    final response = await _client
        .from('saved_tasks')
        .select('*, tasks(*, profiles(ngo_profiles!ngo_profiles_profile_id_fkey(org_name)))')
        .eq('volunteer_id', userId)
        .order('created_at', ascending: false);
        
    return response.map((e) {
      final taskJson = e['tasks'] as Map<String, dynamic>;
      return TaskModel.fromJson(taskJson);
    }).toList();
  }

  Future<void> saveTask(String taskId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    
    await _client.from('saved_tasks').insert({
      'task_id': taskId,
      'volunteer_id': userId,
    });
  }

  Future<void> unsaveTask(String taskId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    
    await _client
        .from('saved_tasks')
        .delete()
        .match({'task_id': taskId, 'volunteer_id': userId});
  }

  // --- Notifications ---
  Future<List<NotificationModel>> getNotifications() async {
    final userId = currentUserId;
    if (userId == null) return [];
    
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
        
    return response.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markNotificationRead(String id) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }

  // --- Certificates ---
  Future<List<CertificateModel>> getCertificates() async {
    final userId = currentUserId;
    if (userId == null) return [];
    
    final response = await _client
        .from('certificates')
        .select()
        .eq('volunteer_id', userId)
        .order('issue_date', ascending: false);
        
    return response.map((e) => CertificateModel.fromJson(e)).toList();
  }
}
