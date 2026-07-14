import 'package:blood_donation_app/app/routes/app_pages.dart';
import 'package:blood_donation_app/app/widgets/common/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/helpers/bangla_datetime_formatter.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../widgets/blood_request/blood_request_card.dart';
import '../controllers/my_blood_post_controller.dart';

class MyBloodPostView extends GetView<MyBloodPostController> {
  const MyBloodPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        title: const Text('আমার সকল পোস্ট',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getBloodPost();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        CustomSearchBar(
                          hint: " রক্তের পোস্ট খুঁজুন",
                          onChanged: controller.onSearchChanged,
                        ),
                        const SizedBox(height: 15),

                        Obx(() {
                          if (controller.isLoading.value) {
                            return SizedBox(
                              height: constraints.maxHeight * .6,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (controller.posts.isEmpty) {
                            return SizedBox(
                              height: constraints.maxHeight * .6,
                              child: const Center(
                                child: Text(
                                  "কোন পোস্ট নেই",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: controller.searchPost.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final postData = controller.searchPost[index];

                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: RequestCard(
                                          theme: Theme.of(context),
                                          name: postData.name ?? "",
                                          hospital:
                                              "হাসপাতাল: ${postData.hospital ?? ""}",
                                          location:
                                              "লোকেশন: ${postData.location ?? ""}",
                                          blood: postData.bloodGroup ?? "",
                                          units:
                                              "পরিমাণ: ${postData.unit} ব্যাগ",
                                          time:
                                              "সময়: ${BanglaDateTimeFormatter.formatTime(postData.time ?? "")}",
                                          date:
                                              "তারিখ: ${BanglaDateTimeFormatter.formatDate(postData.date ?? "")}",
                                          reason: postData.reason ?? "",
                                          description:
                                              "বিবরণ: ${postData.description ?? ""}",
                                          onTap: () {},
                                          onCall: () {},
                                          status:
                                              "অবস্থা : ${postData.status ?? "Urgent"}",
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: Icon(Icons.more_vert),
                                        onSelected: (value) {
                                          if (value == 'delete') {
                                            controller.deletePost(postData.id.toString(),);
                                          }
                                          if (value == 'edit') {
                                            Get.toNamed(Routes.UPDATE_BLOOD_POST, arguments: postData);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text('এডিট'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('মুছে দিন'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        onPressed: () {
          Get.toNamed(Routes.POST_BLOOD);
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
