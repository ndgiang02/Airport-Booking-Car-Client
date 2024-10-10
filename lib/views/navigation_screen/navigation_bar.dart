import 'package:customerapp/controllers/navigation_controller.dart';
import 'package:customerapp/utils/themes/contant_colors.dart';
import 'package:customerapp/views/home_screens/home_screen.dart';
import 'package:customerapp/views/notifition_screen/notifition_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../activities_screen/activities_screen.dart';
import '../manage_screen/manage_screen.dart';

class NavigationPage extends StatelessWidget {

  NavigationPage({super.key});

  final navigationController = Get.put(NavigationController());

  final screens = [
    const HomeScreen(),
    ActivitiesScreen(),
    NotificationScreen(),
    ManageScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: navigationController.selectedIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
              () => Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow:[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                  ),
                  child: BottomNavigationBar(
                    selectedItemColor: ConstantColors.primary,
                    unselectedItemColor: Colors.grey,
                    type: BottomNavigationBarType.fixed,
                    onTap: (index) {
                      navigationController.changeIndex(index);
                    },
                    currentIndex: navigationController.selectedIndex.value,
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home_outlined),
                        activeIcon: const Icon(Icons.home),
                        label: 'home'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.access_time_outlined),
                        activeIcon: const Icon(Icons.access_time_filled_sharp),
                        label: 'activities'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.notifications_none),
                        activeIcon: const Icon(Icons.notifications),
                        label: 'notification'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.account_circle_outlined),
                        activeIcon: const Icon(Icons.account_circle),
                        label: 'account'.tr,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: navigationController.selectedIndex.value * (MediaQuery.of(context).size.width / 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    width: MediaQuery.of(context).size.width / 4,
                    color: ConstantColors.primary,
                  ),
                ),
              ]
          )
      ),
    );
  }
}