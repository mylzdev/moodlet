import 'dart:math';
import 'package:get/get.dart';
import '../models/quote_model/quote_model.dart';

class QuoteController extends GetxController {
  static QuoteController get instance => Get.find();
  final quote = ''.obs;
  final quotes = QuoteModel.quotes;

  final dynamicGreet = 'Good day'.obs;

  @override
  void onInit() {
    super.onInit();
    _generateQuote();
    _generateGreet();
  }

  void _generateQuote() {
    final random = Random();
    quote.value = quotes[random.nextInt(quotes.length)];
  }

  void _generateGreet() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      dynamicGreet.value = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      dynamicGreet.value = 'Good Aftie';
    } else {
      dynamicGreet.value = 'Good Eve';
    }
  }
}
