class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String videoUrl;
  final String category;
  final DateTime publishDate;
  final List<String> keywords;
  final String location;
  final double latitude;
  final double longitude;
  final int views;
  final int likes;
  final int shares;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.videoUrl,
    required this.category,
    required this.publishDate,
    required this.keywords,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.views = 0,
    this.likes = 0,
    this.shares = 0,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      category: json['category'],
      publishDate: DateTime.parse(json['publishDate']),
      keywords: List<String>.from(json['keywords']),
      location: json['location'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      shares: json['shares'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'category': category,
      'publishDate': publishDate.toIso8601String(),
      'keywords': keywords,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'views': views,
      'likes': likes,
      'shares': shares,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final int totalScore;
  final int level;
  final List<String> achievements;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    this.totalScore = 0,
    this.level = 1,
    this.achievements = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      totalScore: json['totalScore'] ?? 0,
      level: json['level'] ?? 1,
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'totalScore': totalScore,
      'level': level,
      'achievements': achievements,
    };
  }
}
