import 'package:blood_donation_app/app/modules/home/controllers/banner_controller.dart';
import 'package:blood_donation_app/app/utils/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shimmer/shimmer.dart';

class BannerCarouselWidget extends StatelessWidget {
  BannerCarouselWidget({super.key});

  final BannerController controller = Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerLoading(context);
      }

      if (controller.bannerList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          CarouselSlider.builder(
            itemCount: controller.bannerList.length,
            itemBuilder: (context, index, realIndex) {
              final banner = controller.bannerList[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CachedNetworkImage(
                    imageUrl: banner.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        _buildShimmerLoadingWidget(context),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 130.0,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                controller.currentIndex.value = index;
              },
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.bannerList.asMap().entries.map((entry) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: controller.currentIndex.value == entry.key ? 18.0 : 6.0,
                height: 6.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: controller.currentIndex.value == entry.key
                      ? AppColors.primary
                      : Colors.grey.withValues(alpha: 0.4),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  // ১. সম্পূর্ণ কার্ড নোটিফিকেশন লোডিং শিমার
  Widget _buildShimmerLoading(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 130.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _buildShimmerLoadingWidget(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(color: theme.colorScheme.surfaceVariant),
    );
  }
}
