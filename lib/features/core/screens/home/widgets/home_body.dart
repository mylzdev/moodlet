import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/text/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/mood_controller.dart';
import 'home_dismissible_card.dart';

class THomeBody extends StatelessWidget {
  const THomeBody({
    super.key,
    required this.moodController,
  });

  final MoodController moodController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            bottom: TSizes.defaultSpace,
          ),
          sliver: Obx(() {
            if (moodController.moods.isEmpty) {
              return SliverToBoxAdapter(
                child: const Center(child: Text('No moods available'))
                    .marginOnly(top: TSizes.spaceBtwSections),
              );
            } else {
              return SliverList(
                delegate:
                    SliverChildListDelegate(_buildMoodList(moodController)),
              );
            }
          }),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: TSizes.spaceBtwSections * 3),
        ),
      ],
    );
  }
}

List<Widget> _buildMoodList(MoodController moodController) {
  final groupedMoods = moodController.groupMoodsByMonth(moodController.moods);
  List<Widget> moodList = [];

  groupedMoods.forEach((monthYear, moods) {
    moodList.add(
      AnimatedSizeAndFade(
        fadeDuration: Durations.extralong3,
        sizeDuration: Durations.extralong1,
        child: moodController.isFetchingLoading.value
            ? const Padding(
                padding: EdgeInsets.all(TSizes.spaceBtwItems),
                child: CircularProgressIndicator.adaptive(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                    primaryBackgroundColor: TColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: TSizes.xs,
                      horizontal: TSizes.sm,
                    ),
                    title: monthYear,
                    titleColor: TColors.white,
                    hasTrailing: true,
                    trailingText: moods.length <= 1
                        ? '${moods.length} Memory'
                        : '${moods.length} Memories',
                  ),
                  ...moods.map((mood) {
                    return THomeDismissibleMoodCard(
                      mood: mood,
                      moodIndex: mood.id!,
                      moodController: moodController,
                    );
                  }).toList(),
                  const SizedBox(height: TSizes.sm),
                ],
              ),
      ),
    );
  });

  return moodList;
}
