import '../../../../utils/constants/image_strings.dart';

class EmotionModel {
  final String emotionImage;
  final String emotionName;
  final bool? isSelected;

  EmotionModel(
      {required this.emotionImage, required this.emotionName, this.isSelected = false});

  static List<EmotionModel> emotionList = [
    EmotionModel(emotionImage: TImages.happy, emotionName: 'Happy'),
    EmotionModel(emotionImage: TImages.sad, emotionName: 'Sad'),
    EmotionModel(emotionImage: TImages.frustated, emotionName: 'Frustated'),
    EmotionModel(emotionImage: TImages.stressed, emotionName: 'Stress'),
    EmotionModel(emotionImage: TImages.loved, emotionName: 'Loved'),
    EmotionModel(emotionImage: TImages.angry, emotionName: 'Angry'),
    EmotionModel(emotionImage: TImages.proud, emotionName: 'Proud'),
    EmotionModel(emotionImage: TImages.anxious, emotionName: 'Anxious'),
    EmotionModel(emotionImage: TImages.excited, emotionName: 'Excited'),
    EmotionModel(emotionImage: TImages.bored, emotionName: 'Bored'),
    EmotionModel(emotionImage: TImages.suprised, emotionName: 'Suprised'),
    EmotionModel(emotionImage: TImages.hopeful, emotionName: 'Hopeful'),
    EmotionModel(emotionImage: TImages.lonely, emotionName: 'Lonely'),
    EmotionModel(emotionImage: TImages.thankful, emotionName: 'Thankful'),
    EmotionModel(emotionImage: TImages.relaxed, emotionName: 'Relaxed'),
    EmotionModel(emotionImage: TImages.amazed, emotionName: 'Amazed'),
  ];
}
