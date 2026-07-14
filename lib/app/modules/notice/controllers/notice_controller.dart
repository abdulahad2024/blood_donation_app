import 'package:get/get.dart';
import '../../../data/db/notification_services/notification_db_service.dart';

class NoticeController extends GetxController {
  var notificationList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  @override
  void onReady() {
    fetchNotifications();
    super.onReady();
  }


  void fetchNotifications() async {
    try {
      isLoading(true);
      var list = await NotificationDbService.getLocalNotifications();
      notificationList.assignAll(list);
    } catch (e) {
      print("Error fetching local notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearAllNotifications() async {
    await NotificationDbService.clearNotifications();
    notificationList.clear();
  }
}