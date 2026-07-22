import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';

class PlaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب جميع الأماكن
  Future<List<Place>> getPlaces() async {
    final snapshot = await _firestore.collection('places').get();

    return snapshot.docs.map((doc) {
      return Place.fromMap(doc.data(), doc.id);
    }).toList();
  }

  // جلب مكان واحد حسب الـ id
  Future<Place?> getPlaceById(String id) async {
    final doc = await _firestore.collection('places').doc(id).get();

    if (doc.exists) {
      return Place.fromMap(doc.data()!, doc.id);
    }

    return null;
  }

  // إضافة مكان جديد
  Future<void> addPlace(Place place) async {
    await _firestore.collection('places').add(place.toMap());
  }

  // تعديل مكان
  Future<void> updatePlace(String id, Place place) async {
    await _firestore.collection('places').doc(id).update(place.toMap());
  }

  // حذف مكان
  Future<void> deletePlace(String id) async {
    await _firestore.collection('places').doc(id).delete();
  }
}
