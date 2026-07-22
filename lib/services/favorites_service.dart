import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  final CollectionReference _favoritesCollection =
      FirebaseFirestore.instance.collection('favorites');

  Future<void> toggleFavorite({
    required String userId,
    required String placeId,
  }) async {
    final querySnapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('placeId', isEqualTo: placeId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await _favoritesCollection.add({
        'userId': userId,
        'placeId': placeId,
      });
    } else {
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  Future<List<String>> getUserFavoritePlaceIds(
      String userId) async {
    final snapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => doc['placeId'] as String)
        .toList();
  }

  Future<bool> isPlaceFavorited(
      String userId,
      String placeId,
  ) async {
    final snapshot = await _favoritesCollection
        .where('userId', isEqualTo: userId)
        .where('placeId', isEqualTo: placeId)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}