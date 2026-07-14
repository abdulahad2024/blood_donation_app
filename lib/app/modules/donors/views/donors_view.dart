import 'package:blood_donation_app/app/routes/app_pages.dart';
import 'package:blood_donation_app/app/utils/constants/app_colors.dart';
import 'package:blood_donation_app/app/utils/constants/app_config.dart';
import 'package:blood_donation_app/app/widgets/common/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../data/helpers/bangla_datetime_formatter.dart';
import '../../../widgets/donors/donors_card.dart';
import '../controllers/donors_controller.dart';

class DonorsView extends GetView<DonorsController> {
  const DonorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DonorsController());

    final length =
        "মোট ব্লাড ডোনার : ${BanglaDateTimeFormatter.toBanglaNumber(controller.donors.length.toString())} জন";

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: CustomAppBar(text: length),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(
                Iconsax.notification,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                Get.toNamed(Routes.NOTICE);
              },
            ),
          ),
        ],
      ),

      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.allDonors,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 5,
              bottom: 16,
            ),
            child: Column(
              children: [
                CustomSearchBar(
                  hint: "রক্তের ডোনার খুঁজুন",
                  onChanged: controller.onSearchChange,
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.searchDonors.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: Text("কোনো ডোনার পাওয়া যায়নি"),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.searchDonors.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final theme = Theme.of(context);
                      final cs = theme.colorScheme;
                      final data = controller.searchDonors[index];

                      String safeText(String? v, {String fallback = ""}) {
                        final s = (v ?? "").trim();
                        if (s.isEmpty || s.toLowerCase() == "null")
                          return fallback;
                        return s;
                      }

                      final String blood = safeText(data.blood);
                      final String name = safeText(
                        data.name,
                        fallback: "নাম নেই",
                      );
                      final String phone = safeText(
                        data.phone,
                        fallback: "নেই",
                      );
                      final String lastDonateRaw = safeText(
                        BanglaDateTimeFormatter.formatBanglaDateTime(
                          data.lastDonationDate,
                        ),
                      );
                      final String lastDonate = lastDonateRaw.isNotEmpty
                          ? "শেষ রক্তদান: $lastDonateRaw"
                          : "রক্তদানের তথ্য এড করে নাই";

                      final String imgPath = safeText(data.profileImage);
                      final String profileUrl = imgPath.isEmpty
                          ? ""
                          : "${AppConfig.baseUrl}$imgPath";

                      return DonorsCard(
                        data: data,
                        theme: theme,
                        cs: cs,
                        profileUrl: profileUrl,
                        name: name,
                        phone: phone,
                        lastDonate: lastDonate,
                        blood: blood,
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String text;

  const CustomAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Iconsax.heart, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConfig.appName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
