class NgoProfileModel {
  final String profileId;
  final String? orgName;
  final String? orgDescription;
  final String? verificationStatus;
  final String? website;
  final String? email;
  final String? phone;
  final String? address;
  final String? mission;
  final String? vision;
  final String? logoUrl;
  final String? coverUrl;
  final String? orgSize;
  final int? foundedYear;
  final List<String>? focusAreas;
  final Map<String, dynamic>? socialLinks;

  NgoProfileModel({
    required this.profileId,
    this.orgName,
    this.orgDescription,
    this.verificationStatus,
    this.website,
    this.email,
    this.phone,
    this.address,
    this.mission,
    this.vision,
    this.logoUrl,
    this.coverUrl,
    this.orgSize,
    this.foundedYear,
    this.focusAreas,
    this.socialLinks,
  });

  factory NgoProfileModel.fromJson(Map<String, dynamic> json) {
    return NgoProfileModel(
      profileId: json['profile_id'] as String,
      orgName: json['org_name'] as String?,
      orgDescription: json['org_description'] as String?,
      verificationStatus: json['verification_status'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      mission: json['mission'] as String?,
      vision: json['vision'] as String?,
      logoUrl: json['logo_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      orgSize: json['org_size'] as String?,
      foundedYear: json['founded_year'] as int?,
      focusAreas: (json['focus_areas'] as List?)?.map((e) => e.toString()).toList(),
      socialLinks: json['social_links'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      if (orgName != null) 'org_name': orgName,
      if (orgDescription != null) 'org_description': orgDescription,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (website != null) 'website': website,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (mission != null) 'mission': mission,
      if (vision != null) 'vision': vision,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (orgSize != null) 'org_size': orgSize,
      if (foundedYear != null) 'founded_year': foundedYear,
      if (focusAreas != null) 'focus_areas': focusAreas,
      if (socialLinks != null) 'social_links': socialLinks,
    };
  }
}
