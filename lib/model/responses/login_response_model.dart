class LoginResponseModel {
  final bool success;
  final String msg;
  final String id;
  final int frontendId;
  final String email;
  final String fullName;
  final String childName;
  final List<int> childIds;

  LoginResponseModel({
    required this.success,
    required this.msg,
    required this.id,
    required this.frontendId,
    required this.email,
    required this.childIds,
    required this.fullName,
    required this.childName,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      msg: json['msg'] ?? '',
      id: json['id'] ?? '',
      frontendId: json['frontendId'] ?? 0,
      email: json['email'] ?? '',
      childIds: (json['childIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      fullName: json['fullName'] ?? '',
      childName: json['childName'] ?? '',
    );
  }

  /// Safely returns the first child id or null if none exist
  int? get firstChildId => childIds.isNotEmpty ? childIds.first : null;
}