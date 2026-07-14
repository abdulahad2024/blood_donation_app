import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../widgets/common/custom_dropdown.dart';
import '../../../widgets/common/custom_elevated_button.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../controllers/update_blood_post_controller.dart';

class UpdateBloodPostView extends GetView<UpdateBloodPostController> {
  const UpdateBloodPostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: AppColors.primary,
          title: const Text('পোস্ট আপডেট করুন',style: TextStyle(color: Colors.white),), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.nameController,
                  hintText: 'আপনার নাম',
                  labelText: 'আপনার নাম',
                  icon: Icons.account_circle_rounded,
                  keyboardType: TextInputType.text,
                ),


                SizedBox(height: 10),



                CustomTextField(
                  controller: controller.phoneController,
                  hintText: 'ফোন নাম্বার',
                  labelText: 'ফোন নাম্বার',
                  icon: Icons.call,
                  keyboardType: TextInputType.text,
                ),



                SizedBox(height: 15),

                CustomTextField(
                  controller: controller.hospitalController,
                  hintText: 'রোগী কোন হসপিটালে',
                  labelText: 'রোগী কোন হসপিটালে',
                  icon: Icons.local_hospital_outlined,
                  keyboardType: TextInputType.text,
                ),

                SizedBox(height: 15),
                CustomTextField(
                  controller: controller.locationController,
                  hintText: 'হসপিটালের ঠিকানা',
                  labelText: 'হসপিটালের ঠিকানা',
                  icon: Icons.location_on_rounded,
                  keyboardType: TextInputType.text,
                ),

                SizedBox(height: 15),
                CustomTextField(
                  controller: controller.unitsController,
                  hintText: 'রক্তের পরিমান কত ব্যাগ',
                  labelText: 'রক্তের পরিমান কত ব্যাগ',
                  icon: Icons.shopping_bag_sharp,
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 15),

                CustomTextField(
                  controller: controller.reasonController,
                  hintText: 'কি কারণে রক্ত দরকার',
                  labelText: 'কি কারণে রক্ত দরকার',
                  icon: Icons.bloodtype,
                  keyboardType: TextInputType.text,
                ),

                SizedBox(height: 15),

                CustomTextField(
                  controller: controller.descriptionController,
                  hintText: 'রোগীর সমস্যা',
                  labelText: 'রোগীর সমস্যা',
                  icon: Icons.report_problem_outlined,
                  keyboardType: TextInputType.text,
                ),

                SizedBox(height: 15),


                Obx(
                      () => CustomDropdown<String>(
                    labelText: "রক্তের গ্রুপ",
                    hintText: "রক্তের গ্রুপ নির্বাচন করুন",
                    icon: Icons.health_and_safety_rounded,
                    value: controller.selectedBlood.value,
                    items: controller.bloodGroups
                        .map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                        .toList(),
                    onChanged: (v) =>
                    controller.selectedBlood.value = v,
                  ),
                ),




                SizedBox(height: 20),



                Obx(() => GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "কত তারিখ রক্ত লাগবে",
                        hintText: "তারিখ নির্বাচন করুন",
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      controller: TextEditingController(
                          text:
                          "${controller.selectedDate.value.toLocal()}".split(' ')[0]),
                      readOnly: true,
                    ),
                  ),
                )),
                SizedBox(height: 20),

                Obx(() => GestureDetector(
                  onTap: () => controller.pickTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "কোন সময় রক্ত লাগবে",
                        hintText: "সময় নির্বাচন করুন",
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      controller: TextEditingController(
                          text: controller.selectedTime.value.format(context)),
                      readOnly: true,
                    ),
                  ),
                )),


                SizedBox(height: 10),


                Obx(
                      () => CustomDropdown<String>(
                    labelText: "অবস্থা",
                    hintText: "অবস্থা নির্বাচন করুন",
                    icon: Iconsax.status4,
                    value: controller.selectedType.value,
                    items: controller.typeGroups
                        .map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                        .toList(),
                    onChanged: (v) =>
                    controller.selectedType.value = v,
                  ),
                ),

                SizedBox(height: 15,),


             Obx(() =>    CustomElevatedButton
               (
               text: "আপডেট করুন",
               isLoading: controller.isLoading.value,
               onPress: () => controller.updateBloodPost(),
               color: AppColors.primary,
               textColor: Colors.white,
             ))





              ],
            ),
          ),
        ),
      ),
    );
  }
}
