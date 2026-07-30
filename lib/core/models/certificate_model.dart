class CertificateModel {
  final String id;
  final String volunteerId;
  final String? taskId;
  final String title;
  final DateTime? issueDate;
  final String? verificationId;
  final String? imageUrl;

  CertificateModel({
    required this.id,
    required this.volunteerId,
    this.taskId,
    required this.title,
    this.issueDate,
    this.verificationId,
    this.imageUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String,
      volunteerId: json['volunteer_id'] as String,
      taskId: json['task_id'] as String?,
      title: json['title'] as String,
      issueDate: json['issue_date'] != null ? DateTime.parse(json['issue_date']) : null,
      verificationId: json['verification_id'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
