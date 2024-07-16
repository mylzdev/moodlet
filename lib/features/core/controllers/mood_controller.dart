import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moodlet/utils/constants/local_storage_key.dart';
import 'settings_controllers/settings_controller.dart';
import 'statistic_controller.dart';
import '../screens/mood_details/mood_details.dart';
import '../../../utils/logging/logger.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import '../models/mood_model/mood_model.dart';
import '../../../data/respositories/mood_repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/popups/popups.dart';
import '../models/activities_model/activities_model.dart';
import '../models/emotion_model/emotion_model.dart';
import '../models/mood_model/mood_choice_model.dart';
import '../screens/bottom_nav/navigation_menu.dart';
import '../screens/mood_details/widgets/mood_details_sleep/mood_details_sleep_time_picker.dart';

class MoodController extends GetxController {
  static MoodController get instance => Get.find();
  final _moodRepository = MoodRepository.instance;
  final _statsController = StatisticController.instance;
  final _settingsController = SettingsController.instance;
  final _localStorage = GetStorage();

  // Database reactive model
  final moods = <MoodModel>[].obs;

  // Selected Mood Variables
  final moodSelectedName = ''.obs;
  String get moodSelectedImagePath =>
      MoodChoiceModel.defaultMood[moodSelectedIndex].moodImage;

  // Selected day variable
  Rx<DateTime?> createdAt = DateTime.now().obs;

  // Variables for Emotion
  final emotionSelectedIndexes = RxList<int>([]);

  // Variables for Activities
  final activitiesSelectedIndexes = RxList<int>([]);

  // Variables for sleep
  final ClockTimeFormat clockTimeFormat = ClockTimeFormat.twentyFourHours;
  final inBedTime = PickedTime(h: 0, m: 0).obs;
  final outBedTime = PickedTime(h: 8, m: 0).obs;
  Rx<PickedTime> intervalBedTime = PickedTime(h: 0, m: 0).obs;

  // Variables for photos
  final isAppbarVisible = true.obs;
  final int maxImages = 4;
  final imageList = <XFile>[].obs;

  // Loading variables
  final isFetchingLoading = false.obs;

  // Note
  final note = TextEditingController();

  @override
  void onInit() {
    fetchAllMoods();
    super.onInit();
  }

  // ---------------------------------------------------- Database Functions ----------------------------------------------------- //

  // Function to fetch all moods
  Future<void> fetchAllMoods() async {
    try {
      isFetchingLoading.value = true;
      List<MoodModel> fetchedMoods = await _moodRepository.fetchMoods();
      moods.assignAll(fetchedMoods);
      await Future.delayed(Durations.short2);
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      moods.clear();
    } finally {
      isFetchingLoading.value = false;
    }
  }

  // Funcation to update mark as favorite
  Future<void> updateIsFavorite(int id, bool isFavorite) async {
    try {
      await _moodRepository.updateIsFavorite(id, isFavorite);
      var mood = moods.firstWhere((mood) => mood.id == id);
      mood.isFavorite = isFavorite;
      moods.refresh();
      TLoggerHelper.info(
          'Mood Markes as ${isFavorite ? "Favorite" : "Not Favorite"}');
    } catch (e) {
      TPopup.errorSnackbar(title: e.toString());
    }
  }

  // Function to group moods by month
  Map<String, List<MoodModel>> groupMoodsByMonth(List<MoodModel> moods) {
    Map<String, List<MoodModel>> groupedMoods = {};

    for (MoodModel mood in moods) {
      DateTime date = DateTime.parse(mood.createdAt);
      String monthYear = DateFormat('MMMM yyyy').format(date);

      if (!groupedMoods.containsKey(monthYear)) {
        groupedMoods[monthYear] = [];
      }

      groupedMoods[monthYear]!.add(mood);
    }

    return groupedMoods;
  }

  // Function to return mood data
  MoodModel getMoodData({int? moodId}) {
    final List<String> selectedEmotionImages = [];
    final List<String> selectedEmotionNames = [];

    for (final index in emotionSelectedIndexes) {
      final EmotionModel emotion = EmotionModel.emotionList[index];
      selectedEmotionImages.add(emotion.emotionImage);
      selectedEmotionNames.add(emotion.emotionName);
    }

    // Populate list of activities
    final List<String> selectedActivityImages = [];
    final List<String> selectedActivityNames = [];

    for (final index in activitiesSelectedIndexes) {
      final ActivitiesModel activity = ActivitiesModel.activityList[index];
      selectedActivityImages.add(activity.activityImage);
      selectedActivityNames.add(activity.activityName);
    }

    // Initalize mood data
    final moodModel = MoodModel(
      id: moodId,
      moodTitle: moodSelectedName.value,
      moodImage: moodSelectedImagePath,
      createdAt: createdAt.value!.toIso8601String(),
      emotionImage: selectedEmotionImages,
      emotionName: selectedEmotionNames,
      note: note.text,
      activitiesImage: selectedActivityImages,
      activitiesName: selectedActivityNames,
      sleepTime: TFormatter.formatSleepTime(intervalBedTime.value, true),
      images: TFormatter.convertXFilesToStringList(imageList),
    );

    return moodModel;
  }

  // Function to add mood
  Future<void> addMood() async {
    try {
      // Get mood data
      final moodData = getMoodData();

      // Save mood data to database
      await _moodRepository.insertMood(moodData);

      // Refresh data database
      fetchAllMoods();

      // Refresh mood counts
      _statsController
          .getMoodCountsByDate(_statsController.selectedMonthYear.value);

      // Redirect screen
      Get.offAll(() => const NavigationScreen());

      // Shows a popup
      if (_localStorage.read(TLocalStorageKey.isTutorialDone) != null) {
        TPopup.successSnackbar(
            title: TTexts.success, message: 'Your mood has been saved');
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } finally {
      clearFieldsAndSelection();
    }
  }

  // Function to update mood
  Future<void> updateMood(int moodId) async {
    try {
      final moodData = getMoodData(moodId: moodId);

      await _moodRepository.updateMood(moodData);

      fetchAllMoods();

      _statsController
          .getMoodCountsByDate(_statsController.selectedMonthYear.value);

      Get.offAll(() => const NavigationScreen());

      TPopup.successSnackbar(
          title: TTexts.success, message: 'Your mood has been updated');
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } finally {
      clearFieldsAndSelection();
    }
  }

  // Function to read mood data and store in the rx values
  void readMoodData(MoodModel mood, bool shouldFetchMoodName) {
    // Set initial values based on fetched mood
    if (shouldFetchMoodName) moodSelectedName.value = mood.moodTitle;
    // Set other initial values accordingly
    note.text = mood.note ?? ''; // Set note field
    createdAt(DateTime.parse(mood.createdAt)); // Set selected date
    // Set selected indexes for emotions
    emotionSelectedIndexes.assignAll(mood.emotionName?.map((e) => EmotionModel
            .emotionList
            .indexWhere((element) => element.emotionName == e)) ??
        []);
    // Set selected indexes for activities
    activitiesSelectedIndexes.assignAll(mood.activitiesName?.map((e) =>
            ActivitiesModel.activityList
                .indexWhere((element) => element.activityName == e)) ??
        []);
    // Set sleep times
    intervalBedTime.value =
        TFormatter.formatStringSleepTime(mood.sleepTime ?? '');
    // Set selected images
    imageList.assignAll(mood.images?.map((e) => XFile(e)).toList() ?? []);
  }

  // Function to fetch mood by id
  Future<void> fetchSingleMoodById({int? moodId}) async {
    try {
      // Early return if moodId is provided and valid
      if (moodId != null) {
        MoodModel? mood = await _moodRepository.fetchMoodById(moodId);
        if (mood != null) {
          readMoodData(mood, true);
          Get.to(() => MoodDetailsScreen(moodData: mood));
        }
        return;
      }

      MoodModel? foundMood;
      for (var m in moods) {
        // Check to see if the mood is existing
        DateTime moodDate = TFormatter.formatStringToDateTime(m.createdAt);
        if (moodDate.year == createdAt.value!.year &&
            moodDate.month == createdAt.value!.month &&
            moodDate.day == createdAt.value!.day) {
          TLoggerHelper.info('Existing mood found');
          foundMood = m;
          break;
        }
      }

      if (foundMood != null) {
        // Assuming fetchMoodById is necessary to refresh or validate the mood
        await _moodRepository.fetchMoodById(foundMood.id!);
        readMoodData(foundMood, false);
        Get.to(() => MoodDetailsScreen(moodData: foundMood));
      } else {
        TLoggerHelper.info(
            'No matching mood found, navigating to create a new mood');
        Get.to(() => const MoodDetailsScreen());
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  // Function to delete mood by id
  Future<void> deleteMoodById(int moodId) async {
    try {
      await _moodRepository.deleteMood(moodId);

      List<MoodModel> fetchedMoods = await _moodRepository.fetchMoods();
      moods.assignAll(fetchedMoods);

      _statsController
          .getMoodCountsByDate(_statsController.selectedMonthYear.value);
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  // Function to confirm deletion of mood data by id
  Future<bool> removeMoodPopup(int moodId, bool instantDelete) async {
    bool isRemove = false;
    await Get.defaultDialog(
      backgroundColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark
          : TColors.light,
      contentPadding: const EdgeInsets.all(TSizes.md),
      titlePadding: const EdgeInsets.only(top: TSizes.md),
      title: 'Remove mood',
      middleText: 'Are you sure you want to delete the selected mood?',
      // Confirm button
      confirm: ElevatedButton(
        onPressed: () async {
          if (instantDelete) await deleteMoodById(moodId);
          Navigator.of(Get.overlayContext!).pop();
          isRemove = true;
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Remove'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () async {
          Navigator.of(Get.overlayContext!).pop();
          isRemove = false;
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );

    return isRemove;
  }

  // Function to filter the moods by name
  Future<void> filterMoodsByTitle(String title) async {
    try {
      final moodlet = await _moodRepository.fetchMoodsByTitle(title);
      moods.assignAll(moodlet);
    } catch (e) {
      await fetchAllMoods();
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  // ---------------------------------------------------- Helper Functions ----------------------------------------------------- //

  // Clear fields and selections
  void clearFieldsAndSelection() {
    moodSelectedName.value = '';
    emotionSelectedIndexes.clear();
    activitiesSelectedIndexes.clear();
    createdAt(DateTime.now());
    note.clear();
    inBedTime(PickedTime(h: 0, m: 0));
    outBedTime(PickedTime(h: 8, m: 0));
    intervalBedTime(PickedTime(h: 0, m: 0));
    imageList.clear();
  }

  // Mood Choice Function
  int get moodSelectedIndex {
    for (int i = 0; i < MoodChoiceModel.defaultMood.length; i++) {
      if (MoodChoiceModel.defaultMood[i].moodText == moodSelectedName.value) {
        return i;
      }
    }
    TLoggerHelper.error('Mood not found');
    return -1;
  }

  // Photo Function --------------------------------------------------------------------------------------------------------------

  Future<void> pickMultipleImagesFromGallery() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage();

      if (pickedImages.isNotEmpty) {
        if (pickedImages.length + imageList.length > maxImages) {
          // Picked images exceeds to max
          TPopup.warningSnackbar(
              title: TTexts.ohSnap, message: 'Maximum image exceeds');
          return;
        }
      }
      for (var pickedImage in pickedImages) {
        if (!imageList.any((image) => image.name == pickedImage.name)) {
          imageList.add(pickedImage);
        } else {
          // Picked image duplicated
          TPopup.warningSnackbar(
              title: TTexts.ohSnap, message: 'Duplicated image detected');
        }
      }
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  Future<void> pickSingleImageFromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) {
        // Unenable to take photo
        TPopup.warningSnackbar(
            title: TTexts.ohSnap,
            message: 'Something went wrong. Please try again');
        return;
      }

      if (imageList.length >= maxImages) {
        // Picked images exceeds to max
        TPopup.warningSnackbar(
            title: TTexts.ohSnap, message: 'Maximum image exceeds');
      } else {
        imageList.add(pickedImage);
      }
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  void removeImage(XFile? image) {
    if (image != null) {
      imageList.remove(image);
    } else {
      return;
    }
  }

  void removeImagePopup(XFile? image) {
    Get.defaultDialog(
      backgroundColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark
          : TColors.light,
      contentPadding: const EdgeInsets.all(TSizes.md),
      titlePadding: const EdgeInsets.only(top: TSizes.md),
      title: 'Remove image',
      middleText: 'Are you sure you want to delete the selected image?',
      // Confirm button
      confirm: ElevatedButton(
        onPressed: () {
          removeImage(image);
          Navigator.of(Get.overlayContext!).pop();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Remove'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );
  }

  // Sleep Function --------------------------------------------------------------------------------------------------------------

  Future<void> showBottomSheetTimePicker() async {
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: TDeviceUtils.getScreenHeight() * 0.7,
          child: const SingleChildScrollView(
            child: MoodDetailsSleepTimePicker(),
          ),
        );
      },
    );
  }

  void updateLabels(PickedTime init, PickedTime end) {
    inBedTime.value = init;
    outBedTime.value = end;
    intervalBedTime.value = formatIntervalTime(
      init: inBedTime.value,
      end: outBedTime.value,
      clockTimeFormat: clockTimeFormat,
    );
  }

  // Emotion Function --------------------------------------------------------------------------------------------------------------

  void toggleEmotionSelection(int index) {
    if (emotionSelectedIndexes.contains(index)) {
      emotionSelectedIndexes.remove(index);
    } else {
      emotionSelectedIndexes.add(index);
    }
    emotionSelectedIndexes.refresh();
  }

  bool isEmotionSelected(int index) {
    return emotionSelectedIndexes.contains(index);
  }

  // Activities Function --------------------------------------------------------------------------------------------------------------

  void toggleActivitiesSelection(int index) {
    if (activitiesSelectedIndexes.contains(index)) {
      activitiesSelectedIndexes.remove(index);
    } else {
      activitiesSelectedIndexes.add(index);
    }
    activitiesSelectedIndexes.refresh();
  }

  bool isActivitiesSelected(int index) {
    return activitiesSelectedIndexes.contains(index);
  }

  // -- Getter methods

  // Method to get mood image for a specific day
  String? getMoodImageForDay(DateTime day) {
    MoodModel? mood = moods.firstWhereOrNull((m) => TFormatter.isSameDate(
        day, TFormatter.formatStringToDateTime(m.createdAt)));

    if (mood == null) {
      return null;
    }

    var emoticons = _settingsController.getEmoticonsTheme();

    for (MoodChoiceModel emoticon in emoticons) {
      if (emoticon.moodText.contains(mood.moodTitle)) {
        return emoticon.moodImage;
      }
    }

    return null;
  }

  String? getMoodImage(MoodModel moodData) {
    var emoticons = _settingsController.getEmoticonsTheme();

    for (var emoticon in emoticons) {
      if (emoticon.moodText.contains(moodData.moodTitle)) {
        return emoticon.moodImage;
      }
    }
    return null;
  }
}
