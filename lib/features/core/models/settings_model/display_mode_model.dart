import '../../../../utils/constants/image_strings.dart';

class DisplayModeModel {
  final String title, image;
  final bool isSelected;
  DisplayModeModel(this.title, this.isSelected, this.image);

  static List<DisplayModeModel> list = [
    DisplayModeModel('System Mode', true, TImages.systemMode),
    DisplayModeModel('Light Mode', false, TImages.lightMode),
    DisplayModeModel('Dark Mode', false, TImages.darkMode),
  ];
}
