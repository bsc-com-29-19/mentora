import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:mentora_frontend/activity/screens/activity_screen.dart';
import 'package:mentora_frontend/chatbot/screens/chatbot_screen.dart';
import 'package:mentora_frontend/journal/screens/journal_screen.dart';
import 'package:mentora_frontend/stats/screens/stats_screen.dart';
import 'package:mentora_frontend/utils/helpers/theme_mode.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = CustomThemeMode.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            // backgroundColor: darkmode ?  TColors,
            indicatorColor:
                darkMode ? Colors.green.shade200 : Colors.green.shade200,
            selectedIndex: controller.selectIndex.value,
            onDestinationSelected: (index) =>
                controller.selectIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.list),
                label: "Activity",
              ),
              NavigationDestination(
                  icon: Icon(Icons.menu_book_rounded), label: "Journal"),
              NavigationDestination(
                  icon: Icon(Icons.android), label: "Therapy"),
              NavigationDestination(icon: Icon(Icons.pie_chart), label: "Stats")
            ]),
      ),
      body: Obx(() => controller.screens[controller.selectIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectIndex = 0.obs;

  final screens = [
    const ActivitiesScreen(),
    JournalScreen(),
    const ChatbotScreen(),
    StatsScreen()
  ];
}
