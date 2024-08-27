import 'package:get/get.dart';

import '../models/notification_model.dart';

class NotificationController extends GetxController {

  var notifications = <Notification>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Thêm thông báo mẫu
    notifications.addAll([
      Notification(
        title: 'Thông báo 1',
        message: 'Bạn có một tin nhắn mới từ quản trị viên.',
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Notification(
        title: 'Thông báo 2',
        message: 'Hãy kiểm tra các cập nhật mới trên ứng dụng.',
        date: DateTime.now().subtract(Duration(hours: 5)),
      ),
      Notification(
        title: 'Thông báo 3',
        message: 'Đã có một lỗi xảy ra khi tải dữ liệu.',
        date: DateTime.now().subtract(Duration(minutes: 30)),
      ),
    ]);
  }

  // Thêm thông báo mới
  void addNotification(Notification notification) {
    notifications.add(notification);
  }

}
