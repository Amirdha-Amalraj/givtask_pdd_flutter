import 'task_model.dart';

class ApplicationModel {
  final String id;
  final String taskId;
  final String applicantId;
  final String? coverNote;
  final String? status;
  final num? matchScore;
  final DateTime? appliedAt;
  final DateTime? updatedAt;
  
  // Joined field from tasks
  final TaskModel? task;

  ApplicationModel({
    required this.id,
    required this.taskId,
    required this.applicantId,
    this.coverNote,
    this.status,
    this.matchScore,
    this.appliedAt,
    this.updatedAt,
    this.task,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      applicantId: json['applicant_id'] as String,
      coverNote: json['cover_note'] as String?,
      status: json['status'] as String?,
      matchScore: json['match_score'] as num?,
      appliedAt: json['applied_at'] != null ? DateTime.parse(json['applied_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      task: (json['tasks'] != null && json['tasks'] is Map) 
          ? TaskModel.fromJson(json['tasks']) 
          : null,
    );
  }
}
