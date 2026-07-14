import 'dart:convert';
import 'package:blood_donation_app/app/data/model/banner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerDbServices {
  static const String _key = 'cached_banners';

  Future<void> saveBanners(List<BannerModel> banners) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList = banners.map((b) => {
      'id': b.id,
      'image_url': b.imageUrl,
    }).toList();

    await prefs.setString(_key, json.encode(jsonList));
  }

  Future<List<BannerModel>> getBanners() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(_key);

    if (cachedData != null) {
      List<dynamic> decodedList = json.decode(cachedData);
      return decodedList.map((json) => BannerModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}