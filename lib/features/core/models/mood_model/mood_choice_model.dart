import '../../../../utils/constants/image_strings.dart';

const String great = 'Great';
const String good = 'Good';
const String okay = 'Okay';
const String poor = 'Poor';
const String bad = 'Bad';

class MoodChoiceModel {
  final String moodImage;
  final String moodText;

  MoodChoiceModel(this.moodImage, this.moodText);

  static List<MoodChoiceModel> defaultMood = [
    MoodChoiceModel(TImages.defaultGreat, great),
    MoodChoiceModel(TImages.defaultGood, good),
    MoodChoiceModel(TImages.defaultOkay, okay),
    MoodChoiceModel(TImages.defaultPoor, poor),
    MoodChoiceModel(TImages.defaultBad, bad),
  ];

  static List<MoodChoiceModel> premiumMoods = [
    MoodChoiceModel(TImages.simpleGreat, 'Great'),
    MoodChoiceModel(TImages.simpleGood, good),
    MoodChoiceModel(TImages.simpleOkay, okay),
    MoodChoiceModel(TImages.simplePoor, poor),
    MoodChoiceModel(TImages.simpleBad, bad),
  ];

  static List<List<MoodChoiceModel>> moods = [
    defaultMood,
    premiumMoods,
  ];
}
