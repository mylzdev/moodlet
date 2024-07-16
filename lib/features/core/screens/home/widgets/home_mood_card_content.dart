import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/shapes/container/card_container.dart';
import '../../../../../common/widgets/image_text/svg_text_vertical.dart';
import '../../../../../common/widgets/text/section_heading.dart';
import '../../../models/mood_model/mood_model.dart';
import '../../../controllers/mood_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';
import '../../../../../utils/constants/sizes.dart';

class THomeMoodCardContent extends StatelessWidget {
  const THomeMoodCardContent({super.key, required this.moodData});

  final MoodModel moodData;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = MoodController.instance;
    final mood = controller.moods.firstWhere((mood) => mood.id == moodData.id);
    return Column(
      children: [
        const SizedBox(height: TSizes.spaceBtwItems),
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Mark as favorite
            IconButton(
              iconSize: TSizes.iconSm,
              onPressed: () {
                mood.isFavorite = !mood.isFavorite;
                controller.updateIsFavorite(mood.id!, mood.isFavorite);
              },
              icon: mood.isFavorite
                  ? const Icon(
                      Iconsax.heart5,
                      color: TColors.primary,
                    )
                  : const Icon(Iconsax.heart),
            ),
            // Edit Button -------------
            IconButton(
              iconSize: TSizes.iconSm,
              onPressed: () async =>
                  controller.fetchSingleMoodById(moodId: moodData.id!),
              icon: const Icon(Iconsax.edit),
            ),
            // Delete Button -------------
            IconButton(
              iconSize: TSizes.iconSm,
              onPressed: () async =>
                  controller.removeMoodPopup(moodData.id!, true),
              icon: const Icon(Iconsax.trash),
            ),
          ],
        ),
        TCardContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.md, vertical: TSizes.defaultSpace),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Mood Image -------------
              Transform.translate(
                offset: const Offset(0, -50),
                child: Image.asset(
                  controller.getMoodImage(moodData)!,
                  height: 50,
                  width: 50,
                ),
              ),
              // Content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date -------------
                  Column(
                    children: [
                      // Day -------------
                      Text(
                          TFormatter.formatDayMonthString(
                              moodData.createdAt, true),
                          style: textTheme.headlineLarge),
                      // Month -------------
                      Text(
                          TFormatter.formatDayMonthString(
                              moodData.createdAt, false),
                          style: textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  // Vertical Divider
                  Container(width: 2, height: 50, color: TColors.darkGrey),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sleep Time -------------
                        TSectionHeading(
                          title: moodData.moodTitle,
                          hasTrailing: true,
                          trailingText: TFormatter.formatStringSleepTime(
                                              moodData.sleepTime!)
                                          .h ==
                                      0 &&
                                  TFormatter.formatStringSleepTime(
                                              moodData.sleepTime!)
                                          .m ==
                                      0
                              ? 'Sleep not recorded'
                              : moodData.sleepTime,
                          backgroundColor:
                              isDark ? TColors.dark : TColors.darkSoftGrey,
                        ),
                        // Data Icons -------------
                        Wrap(
                          spacing: TSizes.sm,
                          children: [
                            // Emotion Icons
                            ...List.generate(
                              moodData.emotionImage!.length,
                              (index) => TSvgTextVertical(
                                svgImage: moodData.emotionImage![index],
                                height: 25,
                                width: 25,
                                padding: TSizes.xs,
                                isSelected: true,
                              ),
                            ),
                            // Activities Icons
                            ...List.generate(
                              moodData.activitiesImage!.length,
                              (index) => TSvgTextVertical(
                                svgImage: moodData.activitiesImage![index],
                                height: 25,
                                width: 25,
                                padding: TSizes.xs,
                                isSelected: true,
                              ),
                            ),
                          ],
                        ),
                        // Notes
                        !moodData.note.isBlank!
                            ? ReadMoreText(
                                moodData.note!,
                                trimLength: 100,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                              ).marginSymmetric(vertical: TSizes.xs)
                            : const SizedBox(height: TSizes.xs),

                        // Photos
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: moodData.images!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                moodData.images!.length == 1 ? 1 : 2,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(TSizes.xs),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(TSizes.cardRadiusSm),
                                child: Image.file(
                                  File(moodData.images![index]),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: isDark
                                        ? TColors.darkerGrey
                                        : TColors.lightContainer,
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
