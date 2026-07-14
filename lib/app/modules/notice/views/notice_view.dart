import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants/app_colors.dart';
import '../controllers/notice_controller.dart';

class NoticeView extends GetView<NoticeController> {
  const NoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final NoticeController noticeController = Get.put(NoticeController());

    return Scaffold(
      backgroundColor: cs.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'নোটিফিকেশনসমূহ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          Obx(() => noticeController.notificationList.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () {
              Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: cs.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: theme.brightness == Brightness.dark ? .45 : .18,
                          ),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: .6),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // কাস্টম ডিলিট আইকন বক্স
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            color: cs.error.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.delete_forever_rounded,
                            color: cs.error,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ডায়ালগ টাইটেল
                        Text(
                          "ক্লিয়ার হিস্ট্রি",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ডায়ালগ ডেসক্রিপশন
                        Text(
                          "আপনি কি নিশ্চিত যে সব নোটিফিকেশন মুছে ফেলতে চান? এই অ্যাকশনটি আর ফিরিয়ে আনা যাবে না।",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // অ্যাকশন বাটনসমূহ
                        Row(
                          children: [
                            // 'না' বাটন
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  foregroundColor: cs.onSurface,
                                ),
                                onPressed: () => Get.back(),
                                child: Text(
                                  "না",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 'হ্যাঁ' বাটন
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: cs.error,
                                  foregroundColor: cs.onError,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  noticeController.clearAllNotifications();
                                  Get.back();
                                },
                                child: Text(
                                  "হ্যাঁ",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary, cs.surface],
            stops: const [0.0, 0.25, 0.55],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (noticeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (noticeController.notificationList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text(
                      "কোনো নোটিফিকেশন নেই",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: noticeController.notificationList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = noticeController.notificationList[index];
                final String title = item['title'] ?? 'নোটিফিকেশন';
                final String body = item['body'] ?? '';
                final String imageUrl = item['image_url'] ?? '';
                final String timeStr = item['time'] ?? '';

                String displayTime = "";
                if (timeStr.isNotEmpty) {
                  try {
                    DateTime dateTime = DateTime.parse(timeStr);
                    displayTime = DateFormat('dd MMM, yyyy - hh:mm a').format(dateTime);
                  } catch (e) {
                    displayTime = timeStr;
                  }
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.notifications_active,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      body,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: cs.onSurface.withValues(alpha: 0.7),
                                        height: 1.4,
                                      ),
                                    ),
                                    if (displayTime.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        displayTime,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey.shade500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (imageUrl.isNotEmpty)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => const SizedBox.shrink(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}