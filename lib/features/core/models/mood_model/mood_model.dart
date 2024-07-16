import 'dart:convert';

class MoodModel {
  final int? id;
  final String moodTitle;
  final String moodImage;
  final String createdAt;
  final String? note;
  final List<String>? emotionImage;
  final List<String>? emotionName;
  final List<String>? activitiesImage;
  final List<String>? activitiesName;
  final String? sleepTime;
  final List<String>? images;
  bool isFavorite;

  MoodModel({
    this.id,
    required this.moodTitle,
    required this.moodImage,
    required this.createdAt,
    this.emotionImage,
    this.emotionName,
    this.activitiesImage,
    this.activitiesName,
    this.note,
    this.sleepTime,
    this.images,
    this.isFavorite = false,
  });

  // Converts a MoodModel instance into a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moodTitle': moodTitle,
      'moodImage': moodImage,
      'createdAt': createdAt,
      'note': note,
      'emotionImage': jsonEncode(emotionImage),
      'emotionName': jsonEncode(emotionName),
      'activitiesImage': jsonEncode(activitiesImage),
      'activitiesName': jsonEncode(activitiesName),
      'sleepTime': sleepTime,
      'images': jsonEncode(images),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Creates a MoodModel instance from a Map
  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] as int?,
      moodTitle: json['moodTitle'] as String,
      moodImage: json['moodImage'] as String,
      createdAt: json['createdAt'] as String,
      note: json['note'] as String?,
      emotionImage: json['emotionImage'] != null
          ? List<String>.from(jsonDecode(json['emotionImage']))
          : [],
      emotionName: json['emotionName'] != null
          ? List<String>.from(jsonDecode(json['emotionName']))
          : [],
      activitiesImage: json['activitiesImage'] != null
          ? List<String>.from(jsonDecode(json['activitiesImage']))
          : [],
      activitiesName: json['activitiesName'] != null
          ? List<String>.from(jsonDecode(json['activitiesName']))
          : [],
      sleepTime: json['sleepTime'] as String?,
      images: json['images'] != null
          ? List<String>.from(jsonDecode(json['images']))
          : [],
      isFavorite: (json['isFavorite'] as int) == 1,
    );
  }
}

class MoodCount {
  final String moodTitle;
  int count;

  MoodCount({
    required this.moodTitle,
    required this.count,
  });

  // Creates a MoodCount instance from a Map
  factory MoodCount.fromJson(Map<String, dynamic> json) {
    return MoodCount(
      moodTitle: json['moodTitle'] as String,
      count: json['count'] as int,
    );
  }
}
