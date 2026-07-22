class FavoriteModel {
  final String id; 
  final String userId;
  final String placeId;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.placeId,
  });


  factory FavoriteModel.fromJson(Map<String, dynamic> json, String documentId) {
    return FavoriteModel(
      id: documentId,
      userId: json['userId'] ?? '',
      placeId: json['placeId'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
    };
  }
}
