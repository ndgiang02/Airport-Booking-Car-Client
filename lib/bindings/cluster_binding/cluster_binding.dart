import 'package:get/get.dart';
import '../../controllers/cluster_controller.dart';


class ClusterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClusterController());
  }
}