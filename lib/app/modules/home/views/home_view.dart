import 'package:blood_donation_app/app/modules/home/views/widgets/banner_carousel_widget.dart';
import 'package:blood_donation_app/app/routes/app_pages.dart';
import 'package:blood_donation_app/app/utils/constants/app_colors.dart';
import 'package:blood_donation_app/app/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../data/helpers/bangla_datetime_formatter.dart';
import '../../../data/helpers/contact_helper.dart';
import '../../../widgets/blood_request/blood_request_card_item.dart';
import '../../../widgets/home/mini_state.dart';
import '../../../widgets/home/quick_action_card.dart';
import '../../../widgets/home/section_header.dart';
import '../../../widgets/shimmer/home_shimmer.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: cs.surface,
            surfaceTintColor: cs.surface,
            expandedHeight: 230,
            titleSpacing: 0,

            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildAppBarTitle(theme, cs),
            ),

            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: kToolbarHeight + 16,
                    left: 16,
                    right: 16,
                  ),
                  child: BannerCarouselWidget(),
                ),
              ),
            ),
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(child: HomeFullScreenShimmer());
            }

            return SliverMainAxisGroup(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            icon: Iconsax.add_circle,
                            title: "রক্তের অনুরোধ",
                            subtitle: "জরুরি প্রয়োজন",
                            color: Colors.redAccent,
                            onTap: () => Get.toNamed(Routes.POST_BLOOD),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionCard(
                            icon: Iconsax.search_normal,
                            title: "ডোনার খুঁজুন",
                            subtitle: "এলাকা অনুযায়ী",
                            color: cs.primary,
                            onTap: () => Get.toNamed(Routes.DONORS_SEARCH),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            icon: Iconsax.shield_tick,
                            title: "ডোনেশন টিপস",
                            subtitle: "রক্ত দান তথ্য",
                            color: Colors.redAccent,
                            onTap: () => Get.toNamed(Routes.DONATION_TIPS),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionCard(
                            icon: Iconsax.health,
                            title: "স্বাস্থ্য টিপস",
                            subtitle: "রক্ত স্বাস্থ্যের তথ্য",
                            color: Colors.redAccent,
                            onTap: () => Get.toNamed(Routes.SASTO_TIPS),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.DONORS),
                            child: MiniStat(
                              theme: theme,
                              icon: Iconsax.profile_2user,
                              label: "ডোনার",
                              value: controller.donorLength,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.SUCCESS_REQUEST),
                            child: MiniStat(
                              theme: theme,
                              icon: Iconsax.heart_tick,
                              label: "সফল",
                              value: controller.successRequestLength,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.BLOOD_REQUEST),
                            child: MiniStat(
                              theme: theme,
                              icon: Iconsax.activity,
                              label: "অনুরোধ",
                              value: controller.bloodRequestLength,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(
                      title: "জরুরি অনুরোধ",
                      actionText: "সব দেখুন",
                      onTap: () => Get.toNamed(Routes.BLOOD_REQUEST),
                    ),
                  ),
                ),

                if (controller.bloodPosts.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text("কোনো রিকোয়েস্ট নেই")),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {
                        final post = controller.bloodPosts[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BloodRequestCard(
                            name: post.name ?? '',
                            date:
                                "তারিখ: ${BanglaDateTimeFormatter.formatDate(post.date ?? "")}",
                            time:
                                "সময়: ${BanglaDateTimeFormatter.formatTime(post.time ?? "")}",
                            description: post.description ?? '',
                            hospital: post.hospital ?? '',
                            location: "ঠিকানা : ${post.location ?? ""}",
                            bloodGroup: post.bloodGroup ?? '',
                            unit: post.unit ?? 0,
                            status: "পোস্টের অবস্থা : ${post.status ?? ''}",
                            reason: "রোগীর সমস্যা : ${post.reason ?? ''}",
                            phone: post.phone ?? '',
                            profileImage:
                                "${AppConfig.baseUrl}/storage/${post.user?.profileImage ?? ""}",
                            profileName: post.user?.name ?? '',
                            createdAt:
                                "${BanglaDateTimeFormatter.formatBanglaDateTime(post.createdAt ?? "")}",
                            onCall: () => ContactHelper.makeCall(post.phone),
                            onShare: () => ContactHelper.shareBloodRequest(post),
                          ),
                        );
                      }, childCount: controller.bloodPosts.length),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(ThemeData theme, ColorScheme cs) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Iconsax.heart, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConfig.appName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "আজই একজনকে বাঁচান ❤️",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.NOTICE);
          },
          icon: Icon(Iconsax.notification, color: cs.onSurface),
        ),
      ],
    );
  }
}
