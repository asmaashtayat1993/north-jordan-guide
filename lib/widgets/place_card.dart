import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/place.dart';

class PlaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _placesCollection =>
      _firestore.collection('places');

  // جميع الأماكن (Explore)
  Stream<List<PlaceModel>> getPlaces() {
    return _placesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlaceModel.fromFirestore(doc);
      }).toList();
    });
  }

  // أعلى الأماكن تقييماً (Home)
  Stream<List<PlaceModel>> getTopRatedPlaces() {
    return _placesCollection
        .orderBy('ratingAvg', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PlaceModel.fromFirestore(doc);
          }).toList();
        });
  }

  // جلب مكان واحد
  Future<PlaceModel?> getPlaceById(String placeId) async {
    final doc = await _placesCollection.doc(placeId).get();

    if (!doc.exists) return null;

    return PlaceModel.fromFirestore(doc);
  }

  // إضافة مكان
  Future<String> addPlace(PlaceModel place) async {
    final data = place.toMap();

    data['createdAt'] = FieldValue.serverTimestamp();

    final doc = await _placesCollection.add(data);

    return doc.id;
  }

  // تعديل مكان
  Future<void> updatePlace(PlaceModel place) async {
    final data = place.toMap();

    data.remove('createdAt');

    await _placesCollection.doc(place.id).update(data);
  }

  // حذف مكان
  Future<void> deletePlace(String placeId) async {
    await _placesCollection.doc(placeId).delete();
  }
}
