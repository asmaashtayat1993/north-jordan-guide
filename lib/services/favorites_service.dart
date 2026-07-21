import 'package:cloud_firestore/cloud_firestore.dart';


class FavoritesService {
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance
      .collection('favorites');

  Future<void> toggleFavorite({
    required String userId,
    required String placeId,
  }) async {
    try {
      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('placeId', isEqualTo: placeId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _favoritesCollection.add({'userId': userId, 'placeId': placeId});
      } else {
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء تعديل المفضلة: $e');
    }
  }

  Future<bool> isPlaceFavorited(String userId, String placeId) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('placeId', isEqualTo: placeId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String> getFavoritesCount(String userId) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .count()
          .get();
      return snapshot.count.toString();
    } catch (e) {
      return '0';
    }
  }

  Future<List<String>> getUserFavoritePlaceIds(String userId) async {
    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => doc['placeId'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}
