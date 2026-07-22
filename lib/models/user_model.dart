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

  // 1️⃣ تُستخدم في [شاشة الملف الشخصي + تسجيل الدخول]
  // لتحويل الماب اللي جاي من الفايربيز إلى Object فلاتر
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      displayName: map['displayName'] ?? 'مستخدم',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? 'User',
      tripsCount: map['tripsCount']?.toInt() ?? 0,
      profileImageUrl:
          map['profileImageUrl'] != null && map['profileImageUrl'] != ''
          ? map['profileImageUrl']
          : null,
      location: map['location'] != null && map['location'] != ''
          ? map['location']
          : null,
    );
  }

  // 2️⃣ تُستخدم في [شاشة إنشاء الحساب + شاشة تعديل البروفايل]
  // لتحويل الـ Object من كودك إلى Map يفهمه الفايربيز ويخزنه
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'tripsCount': tripsCount,
      'profileImageUrl': profileImageUrl ?? '',
      'location': location ?? '',
    };
  }

  // 3️⃣ تُستخدم في [شاشة تعديل الملف الشخصي]
  // عشان نعدل حقل واحد أو أكثر (زي الاسم أو الصورة) ونحافظ على باقي البيانات القديمة
  UserModel copyWith({
    String? displayName,
    String? phoneNumber,
    String? profileImageUrl,
    String? location,
    int? tripsCount,
  }) {
    return UserModel(
      id: id,
      email: email, // الإيميل والـ ID والـ role ما بنعدلهم من البروفايل
      role: role,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      tripsCount: tripsCount ?? this.tripsCount,
    );
  }
}
