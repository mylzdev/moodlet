import 'dart:convert';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/core/models/mood_model/mood_choice_model.dart';
import '../../features/core/models/mood_model/mood_model.dart';
import '../../utils/logging/logger.dart';

/// [MoodRepository] is a service class that manages the mood-related data
/// for the [Moodlet] app using the [sqflite] package for local storage.
/// It handles CRUD operations such as adding, updating, deleting,
/// and fetching moods, as well as managing related data like images and favorites.
class MoodRepository extends GetxService {
  static MoodRepository get instance => Get.find();

  static const int _version = 1;
  static const String tablename = 'moods';

  Future<String> getDBPath() async {
    final databasesPath = await getDatabasesPath();
    return join(databasesPath, tablename);
  }

  /// Create a table database --------------------------------------------
  Future<Database> _database() async {
    final database = openDatabase(
      await getDBPath(),
      onCreate: (db, version) async {
        return db.execute(
            '''CREATE TABLE $tablename(id INTEGER PRIMARY KEY AUTOINCREMENT, 
            moodTitle TEXT NOT NULL, 
            moodImage TEXT NOT NULL, 
            createdAt TEXT NOT NULL,
            note TEXT,
            emotionImage TEXT,
            emotionName TEXT,
            activitiesImage TEXT,
            activitiesName TEXT,
            sleepTime TEXT,
            images TEXT,
            isFavorite INTEGER NOT NULL DEFAULT 0
            )''');
      },
      version: _version,
    );
    return database;
  }

  // Add a mood to the database --------------------------------------------

  Future<void> insertMood(MoodModel moodModel) async {
    try {
      final db = await _database();
      await db.insert(
        tablename,
        moodModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to insert mood. Please try again.';
    }
  }

  // Update mood to the database --------------------------------------------
  Future<void> updateMood(MoodModel moodModel) async {
    try {
      final db = await _database();
      await db.update(
        tablename,
        moodModel.toJson(),
        where: 'id = ?',
        whereArgs: [moodModel.id],
      );
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to update mood. Please try again';
    }
  }

  /// Update mood mark as favorite
  Future<void> updateIsFavorite(int id, bool isFavorite) async {
    try {
      final db = await _database();
      final favoriteValue = isFavorite ? 1 : 0;

      await db.update(
        tablename,
        {'isFavorite': favoriteValue},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to mark mood as favorite';
    }
  }

  /// Delete mood to the database --------------------------------------------
  Future<void> deleteMood(int id) async {
    try {
      final db = await _database();
      await db.delete(
        tablename,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to delete mood. Please try again';
    }
  }

  /// Get all moods to the database --------------------------------------------
  Future<List<MoodModel>> fetchMoods() async {
    try {
      final db = await _database();
      final List<Map<String, dynamic>> maps =
          await db.query(tablename, orderBy: 'createdAt DESC');

      return List.generate(maps.length, (i) {
        return MoodModel.fromJson(maps[i]);
      });
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to fetch moods. Please try again';
    }
  }

  /// Get single mood by id to the database --------------------------------------------
  Future<MoodModel?> fetchMoodById(int id) async {
    try {
      final db = await _database();
      final maps = await db.query(
        tablename,
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? MoodModel.fromJson(maps.first) : null;
    } catch (e) {
      TLoggerHelper.error('Error getting mood by id: $e');
      throw 'Failed to get mood by id';
    }
  }

  /// Get single mood by its title --------------------------------------------
  Future<List<MoodModel>> fetchMoodsByTitle(String title) async {
    try {
      final db = await _database();
      final List<Map<String, dynamic>> maps = await db.query(tablename,
          where: 'moodTitle = ?',
          whereArgs: [title],
          orderBy: 'createdAt DESC');

      return List.generate(maps.length, (i) {
        return MoodModel.fromJson(maps[i]);
      });
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to filter moods by title. Please try again';
    }
  }

  /// Fetch all images from the database --------------------------------------------
  Future<List<String>> fetchAllImages() async {
    try {
      final db = await _database();
      final List<Map<String, dynamic>> maps = await db.query(
        tablename,
        columns: ['images'], // Fetch only the 'images' column
        orderBy: 'createdAt DESC',
      );

      List<String> allImages = [];

      // Iterate through each map to process and add images
      for (var map in maps) {
        var imagesJson = map['images'];
        if (imagesJson != null) {
          // Decode the JSON-encoded string into a List<String>
          List<String> imagePaths = List<String>.from(jsonDecode(imagesJson));
          // Filter out any empty strings and add to the allImages list
          allImages.addAll(imagePaths.where((path) => path.isNotEmpty));
        }
      }

      return allImages;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to fetch images. Please try again';
    }
  }

  /// Get count of each mood by date --------------------------------------------
  Future<List<MoodCount>> fetchMoodCountsByDate(DateTime selectedMonth) async {
    try {
      final db = await _database();
      final mood = MoodChoiceModel.defaultMood;

      // Initialize a list with default counts for each mood
      List<MoodCount> moodCounts = [
        MoodCount(moodTitle: mood[0].moodText, count: 0),
        MoodCount(moodTitle: mood[1].moodText, count: 0),
        MoodCount(moodTitle: mood[2].moodText, count: 0),
        MoodCount(moodTitle: mood[3].moodText, count: 0),
        MoodCount(moodTitle: mood[4].moodText, count: 0),
      ];

      // Format the selected month to match the format of the 'createdAt' field in the database
      final formattedMonth =
          '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}';

      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT moodTitle, COUNT(*) as count FROM $tablename WHERE strftime("%Y-%m", createdAt) = ? GROUP BY moodTitle',
        [formattedMonth],
      );

      // Update the moodCounts list with the actual counts from the database
      for (var map in maps) {
        MoodCount moodCountFromDb = MoodCount.fromJson(map);
        for (var moodCount in moodCounts) {
          if (moodCount.moodTitle == moodCountFromDb.moodTitle) {
            moodCount.count = moodCountFromDb.count;
            break;
          }
        }
      }

      return moodCounts;
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to fetch mood counts. Please try again.';
    }
  }

  /// Fetch moods for specific month
  Future<List<MoodModel>> fetchMoodsForMonth(DateTime selectedMonth) async {
    try {
      final db = await _database();
      final formattedMonth =
          '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}';

      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $tablename WHERE strftime("%Y-%m", createdAt) = ? ORDER BY createdAt',
        [formattedMonth],
      );

      return List.generate(maps.length, (i) {
        return MoodModel.fromJson(maps[i]);
      });
    } catch (e) {
      TLoggerHelper.error(e.toString());
      throw 'Failed to fetch moods for the month. Please try again.';
    }
  }

  // Get total mood entries
  Future<int> getTotalEntries() async {
    try {
      final db = await _database();
      final List<Map<String, dynamic>> result = await db.query(tablename);
      return result.length;
    } catch (e) {
      TLoggerHelper.error('Error getting total entries: $e');
      throw 'Failed to get the total number of entries. Please try again.';
    }
  }

  /// Update images for a specific mood by id --------------------------------------------
  Future<void> updateImages(int id, List<String> newImages) async {
    try {
      final db = await _database();
      String imagesJson = jsonEncode(newImages);

      await db.update(
        tablename,
        {'images': imagesJson},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      TLoggerHelper.error('Error updating images: $e');
      throw 'Failed to update images. Please try again';
    }
  }

  /// Query images
  Future<List<Map<String, dynamic>>> queryImages() async {
    try {
      final db = await _database();
      return await db.query('moods', columns: ['id', 'images']);
    } catch (e) {
      TLoggerHelper.error('Failed to queryImages: $e');
      throw 'Failed to queryImages: $e';
    }
  }
}
