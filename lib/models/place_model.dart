class Place {
  final String id;
  final String name;
  final String category;
  final List<String> images;
  final double ratingAvg;
  final List<String> tags;
  final String workingHours;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.images,
    required this.ratingAvg,
    required this.tags,
    required this.workingHours,
  });

  factory Place.fromMap(Map<String, dynamic> data, String id) {
    return Place(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      ratingAvg: (data['ratingAvg'] ?? 0).toDouble(),
      tags: List<String>.from(data['tags'] ?? []),
      workingHours: data['workingHours'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'images': images,
      'ratingAvg': ratingAvg,
      'tags': tags,
      'workingHours': workingHours,
    };
  }
}
