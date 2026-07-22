import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==========================================================
  // 1️⃣ دالة جلب البيانات: [لشاشة الملف الشخصي]
  // ==========================================================
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // ==========================================================
  // 2️⃣ دالة إنشاء حساب جديد: [لشاشة إنشاء الحساب - Sign Up]
  // ==========================================================
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      // 2. تجهيز الموديل بالبيانات الأولية للسائح
      UserModel newUser = UserModel(
        id: uid,
        displayName: displayName,
        email: email,
        phoneNumber: phoneNumber,
        role: 'tourist',
        tripsCount: 0,
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==========================================================
  // 3️⃣ دالة تسجيل الدخول: [لشاشة تسجيل الدخول - Login]
  // ==========================================================
  Future<UserModel?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // 1. فحص الإيميل والباسورد
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      // 2. الحركة الذكية: استدعاء دالة getUserData لجلب ملف السائح بالكامل!
      return await getUserData(uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
      } else if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {}
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==========================================================
  // 4️⃣ دالة تحديث البيانات: [لشاشة تعديل البروفايل - Edit Profile]
  // ==========================================================
  Future<bool> updateUserData(UserModel updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toMap());
      return true;
    } catch (e) {
      return false; // فشل التحديث
    }
  }

  // ==========================================================
  // 5️⃣ دالة تسجيل الخروج: [لزر تسجيل الخروج في الملف الشخصي]
  // ==========================================================
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
