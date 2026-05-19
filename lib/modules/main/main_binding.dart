import 'package:get/get.dart';
import 'main_controller.dart';
import '../home/home_controller.dart';
import '../explore/explore_controller.dart';
import '../bookings/bookings_controller.dart';
import '../chats/chats_controller.dart';
import '../profile/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ExploreController>(() => ExploreController());
    Get.lazyPut<BookingsController>(() => BookingsController());
    Get.lazyPut<ChatsController>(() => ChatsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
