import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/Screens/DashBoard/dashboard.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/Screens/Products/add_product.dart';
import 'package:mobile_pos/Screens/Report/reports_screen.dart';
import 'package:mobile_pos/Screens/Settings/settings_screen.dart';
import 'package:mobile_pos/constant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    contentPadding: const EdgeInsets.all(20),
                    actionsPadding: const EdgeInsets.only(bottom: 10),
                    backgroundColor: kWhite,
                    title: Text(
                      'Are you sure you want to exit this application?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: kTitleColor, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                          style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: Text(
                            'Yes',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: kMainColor),
                          )),
                      TextButton(
                          style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: kMainColor),
                          )),
                    ],
                  ));
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            HomeScreen(),
            DashboardScreen(),
            AddProduct(fromHome: true),
            Reports(),
            SettingScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: kMainColor,
        unselectedItemColor: Colors.grey.shade700,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(IconlyBold.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: kMainColor, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: 'Add',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Reports',
          ),
          const BottomNavigationBarItem(
            icon: Icon(IconlyBold.setting),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
