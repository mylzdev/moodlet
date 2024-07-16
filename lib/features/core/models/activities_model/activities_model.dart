import '../../../../utils/constants/image_strings.dart';

class ActivitiesModel {
  final String activityImage;
  final String activityName;

  ActivitiesModel({required this.activityImage, required this.activityName});

  static List<ActivitiesModel> activityList = [
    ActivitiesModel(activityImage: TImages.work, activityName: 'Work'),
    ActivitiesModel(activityImage: TImages.music, activityName: 'Music'),
    ActivitiesModel(activityImage: TImages.games, activityName: 'Games'),
    ActivitiesModel(activityImage: TImages.shop, activityName: 'Shop'),
    ActivitiesModel(activityImage: TImages.movies, activityName: 'Movies'),
    ActivitiesModel(activityImage: TImages.travel, activityName: 'Travel'),
    ActivitiesModel(activityImage: TImages.cook, activityName: 'Cook'),
    ActivitiesModel(activityImage: TImages.arts, activityName: 'Arts'),
    ActivitiesModel(activityImage: TImages.workout, activityName: 'Workout'),
    ActivitiesModel(activityImage: TImages.study, activityName: 'Study'),
    ActivitiesModel(activityImage: TImages.date, activityName: 'Date'),
    ActivitiesModel(activityImage: TImages.hangout, activityName: 'Hangout'),
    ActivitiesModel(activityImage: TImages.drink, activityName: 'Drink'),
    ActivitiesModel(activityImage: TImages.party, activityName: 'Party'),
    ActivitiesModel(activityImage: TImages.church, activityName: 'Church'),
    ActivitiesModel(activityImage: TImages.write, activityName: 'Write'),
  ];
}
