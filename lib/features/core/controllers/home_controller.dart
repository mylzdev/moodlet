import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final scrollController = ScrollController();

  final isVisible = false.obs;
  final isPlaying = false.obs;
  final isMoodFilterPressed = false.obs;

  @override
  void onInit() async {
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        isVisible.value = true;
      } else {
        isVisible.value = false;
      }
    });

    super.onInit();
  }

  void backToTop() {
    scrollController.animateTo(
      Offset.zero.dy,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
