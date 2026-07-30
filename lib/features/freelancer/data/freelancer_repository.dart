import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/profile_model.dart';

class FreelancerRepository {
  final SupabaseClient _client;

  FreelancerRepository(this._client);

  Future<ProfileModel?> getProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  Future<List<TaskModel>> getPaidProjects() async {
    final response = await _client
        .from('tasks')
        .select('*, profiles(ngo_profiles!ngo_profiles_profile_id_fkey(org_name))')
        .eq('mode', 'paid')
        .eq('status', 'open')
        .order('created_at', ascending: false);

    return (response as List).map((task) => TaskModel.fromJson(task)).toList();
  }

  Future<TaskModel> getProjectById(String taskId) async {
    final response = await _client
        .from('tasks')
        .select('*, profiles(ngo_profiles!ngo_profiles_profile_id_fkey(org_name))')
        .eq('id', taskId)
        .single();

    return TaskModel.fromJson(response);
  }

  Future<void> submitProposal(String taskId, String coverNote) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _client.from('applications').insert({
      'task_id': taskId,
      'applicant_id': userId,
      'cover_note': coverNote,
      'status': 'applied',
    });
  }

  Future<List<ApplicationModel>> getMyProposals() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('applications')
        .select('*, tasks(*, profiles(ngo_profiles!ngo_profiles_profile_id_fkey(org_name)))')
        .eq('applicant_id', userId)
        .order('applied_at', ascending: false);

    return (response as List).map((app) => ApplicationModel.fromJson(app)).toList();
  }
}
