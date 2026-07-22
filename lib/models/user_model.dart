class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String role;
  final int tripsCount;
  final String? profileImageUrl;
  final String? location;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.tripsCount,
    this.location,
    this.profileImageUrl,
  });

  // 1️⃣ استخدامها: في شاشة الملف الشخصي (لتحويل بيانات الفايربيز إلى Object)
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      displayName: map['displayName'] ?? 'مستخدم',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? 'User',
      tripsCount: map['tripsCount']?.toInt() ?? 0,
      profileImageUrl: map['profileImageUrl'],
      location: map['location'],
    );
  }

  // 2️⃣ إضافتنا الجديدة: استخدامها في شاشة (إنشاء الحساب) + (تعديل الملف الشخصي)
  // لتحويل الـ Object إلى Map عشان نخزنه في الفايربيز
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'tripsCount': tripsCount,
      'profileImageUrl': profileImageUrl ?? '',
      'location': location ?? '',
      // ملاحظة: ما خزنّا الـ id جوا الماب لأنه أصلاً بكون هو اسم الدوكومنت في الفايربيز
    };
  }

  // 3️⃣ إضافتنا الجديدة: استخدامها في شاشة (تعديل الملف الشخصي)
  // لتعديل حقل أو حقلين (مثل الاسم أو الصورة) مع الاحتفاظ بباقي البيانات القديمة
  UserModel copyWith({
    String? displayName,
    String? phoneNumber,
    String? profileImageUrl,
    String? location,
    int? tripsCount,
  }) {
    return UserModel(
      id: id,
      email: email,
      role: role,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      tripsCount: tripsCount ?? this.tripsCount,
    );
  }
}