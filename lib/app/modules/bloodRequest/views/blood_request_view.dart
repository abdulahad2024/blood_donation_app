import 'package:blood_donation_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/helpers/bangla_datetime_formatter.dart';
import '../../../data/helpers/contact_helper.dart';
import '../../../utils/constants/app_config.dart';
import '../../../widgets/blood_request/blood_request_card.dart';
import '../../../widgets/blood_request/blood_request_card_item.dart';
import '../../donors/views/donors_view.dart';
import '../controllers/blood_request_controller.dart';

class BloodRequestView extends GetView<BloodRequestController> {
  const BloodRequestView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(BloodRequestController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final length = "মোট অনুরোধ করেছেন : ${BanglaDateTimeFormatter.toBanglaNumber(controller.bloodPosts.length.toString())} জন";

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: CustomAppBar(text: length,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(
                Iconsax.notification,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Get.toNamed(Routes.NOTICE);
              },
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
          child: Obx( () {

            if(controller.isLoading.value){
              return Center(child: CircularProgressIndicator(),
              );
            }

            if (controller.bloodPosts.isEmpty) {
              return Scaffold(
                body: const Center(child: Text("কোনো রিকোয়েস্ট নেই")),
              );
            }


           return RefreshIndicator(
             onRefresh: controller.getAllBloodRequestPosts,
             child: ListView.separated(
                itemCount: controller.bloodPosts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {


                  final post = controller.bloodPosts[index];
                  final name = post.name ?? '';
                  final hospital = post.hospital ?? '';
                  final location ="ঠিকানা : ${post.location ?? ""}";
                  final phone = post.phone ?? '';
                  final bloodGroup = post.bloodGroup ?? '';
                  final unit = post.unit ?? 0;
                  final time =
                      "সময়: ${BanglaDateTimeFormatter.formatTime(post.time ?? "")}";
                  final date =
                      "তারিখ: ${BanglaDateTimeFormatter.formatDate(post.date ?? "")}";
                  final status = "পোস্টের অবস্থা : ${post.status ?? ''}";
                  final reason = "রোগীর সমস্যা : ${post.reason ?? ''}";
                  final description = "${post.description ?? ''}";
                  final createdAt = "${BanglaDateTimeFormatter.formatBanglaDateTime(post.createdAt ?? "")}";
                  final profileImage =
                      "${AppConfig.baseUrl}/storage/${post.user?.profileImage ?? ""}";
                  final profileName = post.user?.name ?? '';







                  return BloodRequestCard(
                    name: name,
                    date: date,
                    time: time,
                    description: description,
                    hospital: hospital,
                    location: location,
                    bloodGroup: bloodGroup,
                    unit: unit,
                    status: status,
                    reason: reason,
                    phone: phone,
                    profileImage: profileImage,
                    profileName: profileName,
                    createdAt: createdAt,
                    onCall: () => ContactHelper.makeCall(post.phone),
                    onShare: () => ContactHelper.shareBloodRequest(post),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 12,);
              },
              ),
           );

          }

          ),
        ),
      ),
    );
  }
}
