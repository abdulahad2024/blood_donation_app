import 'dart:convert';

import 'package:blood_donation_app/app/data/helpers/bangla_datetime_formatter.dart';
import 'package:blood_donation_app/app/data/services/blood_services.dart';
import 'package:blood_donation_app/app/modules/bloodRequest/controllers/blood_request_controller.dart';
import 'package:blood_donation_app/app/modules/donors/controllers/donors_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/firebase_notification/notification_service.dart';
import '../../../data/model/blood_request.dart';
import '../../successRequest/controllers/success_request_controller.dart';

class HomeController extends GetxController {

  final BloodServices bloodServices = BloodServices();

  final RxBool isLoading = false.obs;
  final RxList<BloodRequestPost> bloodPosts = <BloodRequestPost>[].obs;



  @override
  void onInit() {
    super.onInit();
    getBloodRequestFivePosts();
    _checkNotificationPermission();
  }

  @override
  void onReady() {
    super.onReady();
    getBloodRequestFivePosts();

  }

  void _checkNotificationPermission() async {
    try {
      await NotificationService().requestNotificationPermission();
    } catch (e) {
      print("Error requesting notification permission: $e");
    }
  }



  void getBloodRequestFivePosts() async {

    try {

      isLoading.value = true;

      final response = await bloodServices.allBloodRequest();
      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {

        List data = result['data'];

        bloodPosts.clear();

        for (var item in data.take(5)) {
          bloodPosts.add(BloodRequestPost.fromJson(item));
        }

      } else {
        Get.snackbar(
          "Something went wrong",
          "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  final DonorsController donorsController = Get.put(DonorsController());
  final BloodRequestController bloodRequestController = Get.put(BloodRequestController());
  final SuccessRequestController successRequestController = Get.put(SuccessRequestController());



  late final donorLength = BanglaDateTimeFormatter.toBanglaNumber(donorsController.searchDonors.length.toString());
  late final bloodRequestLength = BanglaDateTimeFormatter.toBanglaNumber(bloodRequestController.bloodPosts.length.toString());
  late final successRequestLength = BanglaDateTimeFormatter.toBanglaNumber(successRequestController.bloodPosts.length.toString());






}