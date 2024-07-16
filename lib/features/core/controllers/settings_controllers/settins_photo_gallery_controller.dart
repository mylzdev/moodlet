import 'package:get/get.dart';
import '../../../../data/respositories/mood_repository.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/popups.dart';
import '../../screens/settings/widgets/photo_gallery.dart';

class PhotoGalleryController extends GetxController {
  final _moodRepository = MoodRepository.instance;

  final images = RxList<String>();

  @override
  void onInit() async {
    await fetchImages();
    super.onInit();
  }

  void openGallery(List<String> imagePaths, int initialIndex) {
    Get.to(
      () => GalleryScreen(
        imagePaths: imagePaths,
        initialIndex: initialIndex,
      ),
    );
  }

  // Function to fetch all the images
  Future<void> fetchImages() async {
    try {
      final fetchImages = await _moodRepository.fetchAllImages();
      images.addAll(fetchImages);
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    } 
  }
}
