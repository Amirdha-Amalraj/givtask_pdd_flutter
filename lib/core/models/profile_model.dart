class ProfileModel {
  final String id;
  final String? role;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;
  final int? impactScore;
  final String? tier;
  final bool? isActive;
  final DateTime? createdAt;
  final List<String>? capabilities;
  final String? phone;
  final String? location;
  final List<String>? interests;
  final List<String>? languages;
  final String? availability;
  final String? education;
  final String? experience;
  final String? volunteerPreferences;

  ProfileModel({
    required this.id,
    this.role,
    this.fullName,
    this.avatarUrl,
    this.bio,
    this.impactScore,
    this.tier,
    this.isActive,
    this.createdAt,
    this.capabilities,
    this.phone,
    this.location,
    this.interests,
    this.languages,
    this.availability,
    this.education,
    this.experience,
    this.volunteerPreferences,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      role: json['role'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      impactScore: json['impact_score'] as int?,
      tier: json['tier'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      capabilities: (json['capabilities'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      interests: (json['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      languages: (json['languages'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      availability: json['availability'] as String?,
      education: json['education'] as String?,
      experience: json['experience'] as String?,
      volunteerPreferences: json['volunteer_preferences'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'impact_score': impactScore,
      'tier': tier,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'capabilities': capabilities,
      'phone': phone,
      'location': location,
      'interests': interests,
      'languages': languages,
      'availability': availability,
      'education': education,
      'experience': experience,
      'volunteer_preferences': volunteerPreferences,
    };
  }
}
