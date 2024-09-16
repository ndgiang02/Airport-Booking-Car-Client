import 'package:customerapp/controllers/bottomnavigation_controller.dart';
import 'package:customerapp/utils/themes/contant_colors.dart';
import 'package:customerapp/views/home_screens/home_screen.dart';
import 'package:customerapp/views/notifition_screen/notifition_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../activities_screen/activities_screen.dart';
import '../manage_screen/manage_screen.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  final screens = [
    HomeScreen(),
    ActivitiesScreen(),
    NotificationScreen(),
    ManageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: bottomNavigationController.selectedIndex.value,
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
                          offset: Offset(0, 3),
                        ),
                      ]
                  ),
                  child: BottomNavigationBar(
                    selectedItemColor: ConstantColors.primary,
                    unselectedItemColor: Colors.grey,
                    type: BottomNavigationBarType.fixed,
                    onTap: (index) {
                      bottomNavigationController.changeIndex(index);
                    },
                    currentIndex: bottomNavigationController.selectedIndex.value,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'home'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.access_time_outlined),
                        activeIcon: Icon(Icons.access_time_filled_sharp),
                        label: 'activities'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_none),
                        activeIcon: Icon(Icons.notifications),
                        label: 'notification'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle_outlined),
                        activeIcon: Icon(Icons.account_circle),
                        label: 'account'.tr,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: bottomNavigationController.selectedIndex.value * (MediaQuery.of(context).size.width / 4),
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