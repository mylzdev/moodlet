import '../../../../utils/constants/image_strings.dart';

class MoodChoiceModel {
  final String moodImage;
  final String moodText;

  MoodChoiceModel(this.moodImage, this.moodText);

  static List<MoodChoiceModel> defaultMood = [
    MoodChoiceModel(TImages.defaultGreat, 'Great'),
    MoodChoiceModel(TImages.defaultGood, 'Good'),
    MoodChoiceModel(TImages.defaultOkay, 'Okay'),
    MoodChoiceModel(TImages.defaultPoor, 'Poor'),
    MoodChoiceModel(TImages.defaultBad, 'Bad'),
  ];

  static List<MoodChoiceModel> premiumMoods = [
    MoodChoiceModel(TImages.simpleGreat, 'Great'),
    MoodChoiceModel(TImages.simpleGood, 'Good'),
    MoodChoiceModel(TImages.simpleOkay, 'Okay'),
    MoodChoiceModel(TImages.simplePoor, 'Poor'),
    MoodChoiceModel(TImages.simpleBad, 'Bad'),
  ];

  static List<List<MoodChoiceModel>> moods = [
    defaultMood,
    premiumMoods,
  ];
}
