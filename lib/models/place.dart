import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  // Document ID من Firestore
  final String id;
  // اسم المكان
  final String name;
  // وصف المكان
  final String description;
  // التصنيف (أثري، مطعم، حديقة...)
  final String category;
  // الموقع الجغرافي (تم التعديل ليتوافق مع GeoPoint في Firestore)
  final GeoPoint? location;
  // قائمة الصور
  final List<String> images;
  // متوسط التقييم
  final double ratingAvg;
  // السعر
  final double price;
  // هل المكان مميز؟
  final bool isPopular;
  // ساعات العمل
  final String workingHours;
  // الوسوم
  final List<String> tags;
  // تاريخ الإنشاء
  final Timestamp? createdAt;
  // رقم الهاتف
  final String phone;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.location,
    required this.images,
    required this.ratingAvg,
    required this.price,
    required this.isPopular,
    required this.workingHours,
    required this.tags,
    this.createdAt,
    this.phone = '',
  });

  /// تحويل بيانات Firestore إلى PlaceModel
  factory PlaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PlaceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',

      // استقبال الموقع كـ GeoPoint مباشرة
      location: data['location'],

      // التعديل هنا: قراءة الصور من imageUrl أو images تحسباً لأي تغيير
      images: List<String>.from(data['imageUrl'] ?? data['images'] ?? []),

      ratingAvg: double.tryParse(data['ratingAvg']?.toString() ?? '0') ?? 0.0,
      price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      isPopular: data['isPopular'] ?? false,
      workingHours: data['workingHours'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: data['createdAt'],
      phone: data['phone'] ?? '',
    );
  }

  /// تحويل PlaceModel إلى Map لإرسالها إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'location': location, // حفظها كـ GeoPoint
      'images': images, // إعادة حفظها باسم imageUrl ليتطابق مع الداتا بيس
      'ratingAvg': ratingAvg,
      'price': price,
      'isPopular': isPopular,
      'workingHours': workingHours,
      'tags': tags,
      'createdAt': createdAt,
      'phone': phone,
    };
  }
}
