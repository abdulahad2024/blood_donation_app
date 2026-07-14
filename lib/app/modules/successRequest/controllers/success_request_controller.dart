import 'dart:convert';
import 'package:blood_donation_app/app/data/helpers/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/blood_request.dart';
import '../../../data/services/blood_services.dart';

class SuccessRequestController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<BloodRequestPost> bloodPosts = <BloodRequestPost>[].obs;
  final BloodServices bloodServices = BloodServices();

  @override
  void onInit() {
    super.onInit();
    getBloodRequestSuccessPosts();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getBloodRequestSuccessPosts();

  }

  void getBloodRequestSuccessPosts() async {
    try {
      isLoading.value = true;

      final response = await bloodServices.statusBloodRequest();
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == true) {
        List data = result['data'];

        bloodPosts.clear();

        for (var item in data) {
          bloodPosts.add(BloodRequestPost.fromJson(item));
        }
      } else {
        showAppSnackbar(
          title: "Something went wrong",
          message: "Something went wrong",
          isError: true,
        );
      }
    } catch (e) {
      showAppSnackbar(
        title: "Something went wrong",
        message: "Something went wrong",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
