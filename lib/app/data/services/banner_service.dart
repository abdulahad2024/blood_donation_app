
import 'dart:convert';

import 'package:blood_donation_app/app/data/model/banner_model.dart';
import 'package:blood_donation_app/app/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;

class BannerService {
  static const String apiUrl = "${AppConfig.baseUrl}/banner.json";

  static Future<List<BannerModel>?> fetchBanners() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          List<dynamic> data = responseData['data'];
          return data.map((json) => BannerModel.fromJson(json)).toList();
        }
      }
      return null;
    } catch (e) {
      print("Error fetching banners: $e");
      return null;
    }
  }
}