class TaskModel {
  final String id;
  final String? ngoId;
  final String? title;
  final String? description;
  final List<String>? requiredSkills;
  final String? mode;
  final num? rate;
  final num? budget;
  final DateTime? deadline;
  final String? location;
  final bool? isRemote;
  final String? complexity;
  final String? status;
  final bool? isFlagged;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? volunteerHours;
  final DateTime? eventDate;
  final int? volunteersNeeded;
  final String? category;
  
  // Joined field from ngo_profiles
  final String? ngoName;

  TaskModel({
    required this.id,
    this.ngoId,
    this.title,
    this.description,
    this.requiredSkills,
    this.mode,
    this.rate,
    this.budget,
    this.deadline,
    this.location,
    this.isRemote,
    this.complexity,
    this.status,
    this.isFlagged,
    this.createdAt,
    this.updatedAt,
    this.volunteerHours,
    this.eventDate,
    this.volunteersNeeded,
    this.category,
    this.ngoName,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      ngoId: json['ngo_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      requiredSkills: (json['required_skills'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      mode: json['mode'] as String?,
      rate: json['rate'] as num?,
      budget: json['budget'] as num?,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      location: json['location'] as String?,
      isRemote: json['is_remote'] as bool?,
      complexity: json['complexity'] as String?,
      status: json['status'] as String?,
      isFlagged: json['is_flagged'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      volunteerHours: json['volunteer_hours'] as int?,
      eventDate: json['event_date'] != null ? DateTime.parse(json['event_date']) : null,
      volunteersNeeded: json['volunteers_needed'] as int?,
      category: json['category'] as String?,
      ngoName: () {
        if (json['ngo_profiles'] != null && json['ngo_profiles'] is Map) {
          return json['ngo_profiles']['org_name'] as String?;
        }
        if (json['profiles'] != null && json['profiles'] is Map) {
          final ngoProfiles = json['profiles']['ngo_profiles'];
          if (ngoProfiles is Map) {
            return ngoProfiles['org_name'] as String?;
          } else if (ngoProfiles is List && ngoProfiles.isNotEmpty) {
            return ngoProfiles.first['org_name'] as String?;
          }
        }
        return null;
      }(),
    );
  }
}
