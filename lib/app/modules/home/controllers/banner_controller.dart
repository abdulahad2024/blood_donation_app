import 'package:blood_donation_app/app/data/db/banner_db_services.dart';
import 'package:blood_donation_app/app/data/model/banner_model.dart';
import 'package:blood_donation_app/app/data/services/banner_service.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  var bannerList = <BannerModel>[].obs;
  var isLoading = true.obs;
  var currentIndex = 0.obs;

  final BannerDbServices _dbService = BannerDbServices();

  @override
  void onInit() {
    loadBanners();
    super.onInit();
  }

  void loadBanners() async {
    var localBanners = await _dbService.getBanners();
    if (localBanners.isNotEmpty) {
      bannerList.assignAll(localBanners);
      isLoading(false);
    }

    try {
      if (bannerList.isEmpty) isLoading(true);

      var remoteBanners = await BannerService.fetchBanners();

      if (remoteBanners != null && remoteBanners.isNotEmpty) {
        await _dbService.saveBanners(remoteBanners);

        bannerList.assignAll(remoteBanners);
      }
    } catch (e) {
      print("Error loading banners: $e");
    } finally {
      isLoading(false);
    }
  }
}