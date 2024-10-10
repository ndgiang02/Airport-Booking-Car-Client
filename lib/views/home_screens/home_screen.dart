import 'package:customerapp/controllers/home_controller.dart';
import 'package:customerapp/utils/themes/contant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/preferences/preferences.dart';
import '../../utils/themes/text_style.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final TextEditingController codeController = TextEditingController();

  final homeController = Get.put(HomeController());

  String? name =  Preferences.getString(Preferences.userName);

  final PageController _pageController = PageController();

  final List<String> items = [
    "Welcome to the app!",
    "Easy to use",
    "Fast and Secure",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  '${'hello'.tr}, ${name!}',
                  style: CustomTextStyles.app,
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select_service'.tr,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Let’s choose the transport service suitable for you'.tr),
              const SizedBox(height: 8),
              buildServiceCard(
                title: 'airport cluster'.tr,
                imagePath: 'assets/images/sedan.png',
                destinationScreen: '/cluster',
              ),
              buildServiceCard(
                title: 'airport'.tr,
                imagePath: 'assets/images/sedan.png',
                destinationScreen: '/airport',
              ),
              buildServiceCard(
                title: 'longtrip'.tr,
                imagePath: 'assets/images/sedan.png',
                destinationScreen: '/longtrip',
              ),
              buildServiceCard(
                title: 'show_info_fly'.tr,
                imagePath: 'assets/images/flight.jpg',
                destinationScreen: '/flight',
              ),
              const SizedBox(
                height: 10,
              ),
              Text('highlight'.tr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                   homeController.changePage(page);
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 2,
                            color: ConstantColors.primary,
                          )
                        ),
                        child: Center(
                          child: Text(
                            items[index],
                            style: CustomTextStyles.header,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => buildDot(index, homeController.currentPage.value)),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index, int currentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: currentPage == index ? Colors.blueAccent : Colors.grey,
          width: 0.5,
        ),
        color: currentPage == index ? Colors.blueAccent : Colors.transparent,
      ),
    );
  }

  Widget buildServiceCard({
    required String title,
    required String imagePath,
    required String destinationScreen,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          destinationScreen,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        title,
                        style: CustomTextStyles.header
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}