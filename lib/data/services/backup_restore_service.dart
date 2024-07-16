import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../respositories/mood_repository.dart';
import '../../utils/logging/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class BackupRestoreService extends GetxService {
  static BackupRestoreService get instance => Get.find();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MoodRepository _moodRepository = MoodRepository.instance;

  // Constants
  static const String backupsPath = 'backups';
  static const String imagesPath = 'images';
  static const String dbFileName = 'moodlet.db';
  static const String totalEntriesFileName = 'total_entries.txt';
  static const String totalEntriesPath = 'total_entries';
  static const String errorMessage = 'Something went wrong. Please try again';

  final tableName = MoodRepository.tablename;
  Future<String> get _getDatabasePath async =>
      await _moodRepository.getDBPath();

  // Rx variables
  final RxInt _totalBackupImages = 0.obs;
  final RxInt _backedUpImages = 0.obs;
  final RxInt _totalRestoreImages = 0.obs;
  final RxInt _restoredImages = 0.obs;

  // Rx getter
  int get totalBackupImages => _totalBackupImages.value;
  int get backedUpImages => _backedUpImages.value;
  int get totalRestoreImages => _totalRestoreImages.value;
  int get restoredImages => _restoredImages.value;

  Future<int> get totalBackupEntries async =>
      await MoodRepository.instance.getTotalEntries();

  /// Backs up the database to Firebase Storage
  Future<void> backupDatabase() async {
    try {
      final dbPath = await _getDatabasePath;
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        final userId = _auth.currentUser?.uid;
        final ref = _storage.ref().child('$backupsPath/$userId/$dbFileName');
        await ref.putFile(dbFile);
        await storeTotalEntries();
      } else {
        throw 'Database file does not exist';
      }
    } catch (e) {
      _handleException(e, 'backupDatabase');
    }
  }

  /// Restores the database from Firebase Storage
  Future<void> restoreDatabase() async {
    try {
      final dbPath = await _getDatabasePath;
      final userId = _auth.currentUser?.uid;
      final ref = _storage.ref().child('$backupsPath/$userId/$dbFileName');

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final File downloadToFile = File('${appDocDir.path}/$dbFileName');

      await ref.writeToFile(downloadToFile);
      await downloadToFile.copy(dbPath);
    } catch (e) {
      _handleException(e, 'restoreDatabase');
    }
  }

  /// Backs up the images to Firebase Storage
  Future<void> backupImages() async {
    try {
      final dbPath = await _getDatabasePath;
      final dbFile = File(dbPath);
      final userId = _auth.currentUser?.uid;

      if (await dbFile.exists()) {
        final allImagePaths = await _getAllImagePaths();

        final previouslyBackedUpImages =
            await _getPreviouslyBackedUpImages(userId);

        final newImagePaths = allImagePaths.where((imagePath) {
          return !previouslyBackedUpImages.contains(basename(imagePath));
        }).toList();

        _totalBackupImages.value = newImagePaths.length;
        _backedUpImages.value = 0;
        for (var imagePath in newImagePaths) {
          await _backupSingleImage(imagePath, userId);
        }
      } else {
        throw 'Database file not found';
      }
    } catch (e) {
      _handleException(e, 'backupImages');
    }
  }

  /// Restores the images from Firebase Storage
  Future<void> restoreImages() async {
    try {
      final userId = _auth.currentUser?.uid;
      final moodImagesMap = await _getMoodImagesMap();

      _totalRestoreImages.value = await _getTotalBackupImages(userId);
      _restoredImages.value = 0;

      for (var entry in moodImagesMap.entries) {
        await _restoreImagesForMood(entry, userId);
      }
    } catch (e) {
      _handleException(e, 'restoreImages');
    }
  }

  /// Retrieves the backup creation time
  Future<String> getBackupCreationTime() async {
    try {
      final userId = _auth.currentUser?.uid;
      final ref = _storage.ref().child('$backupsPath/$userId/$dbFileName');
      final metadata = await ref.getMetadata();
      final DateTime? createdAt = metadata.timeCreated;

      return createdAt != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt)
          : 'No data record yet';
    } catch (e) {
      return 'No data record yet';
    }
  }

  /// Checks if the user has a backup
  Future<bool> get userHasBackup async {
    try {
      final userId = _auth.currentUser?.uid ?? 'anonymous';
      final ref = _storage.ref().child('$backupsPath/$userId/$dbFileName');
      await ref.getMetadata();
      return true;
    } on FirebaseException {
      return false;
    }
  }

  /// Stores the total entries to Firebase Storage
  Future<void> storeTotalEntries() async {
    try {
      final userId = _auth.currentUser?.uid;
      final storageRef = _storage.ref().child(
          '$backupsPath/$userId/$totalEntriesPath/$totalEntriesFileName');
      final totalEntries = await _moodRepository.getTotalEntries();
      await storageRef.putString(totalEntries.toString());
    } catch (e) {
      _handleException(e, 'storeTotalEntries');
    }
  }

  /// Retrieves the total entries from Firebase Storage
  Future<String> retrieveTotalEntries() async {
    try {
      final userId = _auth.currentUser?.uid;
      final storageRef = _storage.ref().child(
          '$backupsPath/$userId/$totalEntriesPath/$totalEntriesFileName');
      final data = await storageRef.getData();
      return utf8.decode(data!);
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return '';
      }
      return '';
    } catch (e) {
      _handleException(e, 'retrieveTotalEntries');
      return '';
    }
  }

  // Private helper methods

  /// Retrieves all image paths from the database
  Future<List<String>> _getAllImagePaths() async {
    final maps = await _moodRepository.queryImages();
    List<String> allImagePaths = [];
    for (var map in maps) {
      var imagesJson = map['images'];
      if (imagesJson != null) {
        List<String> imagePaths = List<String>.from(jsonDecode(imagesJson));
        allImagePaths.addAll(imagePaths);
      }
    }
    return allImagePaths;
  }

  /// Retrieves previously backed up images from Firebase Storage
  Future<List<String>> _getPreviouslyBackedUpImages(String? userId) async {
    final ListResult result = await _storage
        .ref()
        .child('$backupsPath/$userId/$imagesPath')
        .listAll();
    return result.items.map((ref) => ref.name).toList();
  }

  /// Backs up a single image to Firebase Storage
  Future<void> _backupSingleImage(String imagePath, String? userId) async {
    final imageFile = File(imagePath);
    if (await imageFile.exists()) {
      final tempDir = await getTemporaryDirectory();
      final compressedImagePath = join(tempDir.path, basename(imagePath));
      final compressedImageFile = File(compressedImagePath)
        ..writeAsBytesSync(await imageFile.readAsBytes());

      final imageRef = _storage
          .ref()
          .child('$backupsPath/$userId/$imagesPath/${basename(imagePath)}');
      await imageRef.putFile(compressedImageFile);

      _backedUpImages.value++;
    }
  }

  /// Retrieves a map of mood IDs to their corresponding image paths
  Future<Map<int, List<String>>> _getMoodImagesMap() async {
    final maps = await _moodRepository.queryImages();
    Map<int, List<String>> moodImagesMap = {};
    for (var map in maps) {
      var id = map['id'] as int;
      var imagesJson = map['images'];
      if (imagesJson != null) {
        List<String> imagePaths = List<String>.from(jsonDecode(imagesJson));
        moodImagesMap[id] = imagePaths;
      }
    }
    return moodImagesMap;
  }

  /// Restores images for a specific mood from Firebase Storage
  Future<void> _restoreImagesForMood(
      MapEntry<int, List<String>> entry, String? userId) async {
    int moodId = entry.key;
    List<String> originalImages = entry.value;
    List<String> updatedImages = [];

    for (var imagePath in originalImages) {
      final imageRef = _storage
          .ref()
          .child('$backupsPath/$userId/$imagesPath/${basename(imagePath)}');
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final File downloadToFile =
          File('${appDocDir.path}/${basename(imagePath)}');

      try {
        await imageRef.writeToFile(downloadToFile);
        if (await downloadToFile.exists()) {
          updatedImages.add(downloadToFile.path);
        } else {
          TLoggerHelper.error('File was not created: $downloadToFile');
        }
      } catch (e) {
        TLoggerHelper.error('Error restoring image $imagePath: $e');
      }
    }

    if (updatedImages.isNotEmpty) {
      await _moodRepository.updateImages(moodId, updatedImages);
      _restoredImages.value += updatedImages.length;
    }
  }

  /// Retrieves the total number of backup images from Firebase Storage
  Future<int> _getTotalBackupImages(String? userId) async {
    try {
      final ListResult result = await _storage
          .ref()
          .child('$backupsPath/$userId/$imagesPath')
          .listAll();
      return result.items.length;
    } catch (e) {
      TLoggerHelper.error('Error retrieving total backup images: $e');
      throw 'Failed to retrieve total backup images';
    }
  }

  /// Handles exceptions by logging and throwing a generic error message
  void _handleException(Object e, String methodName) {
    TLoggerHelper.error('$errorMessage in $methodName: $e');
    throw errorMessage;
  }
}
