import 'package:swasth_bharat/constants/global_variables.dart';
import 'package:swasth_bharat/features/account/screens/account_screen.dart';
import 'package:swasth_bharat/features/cart/screens/cart_screen.dart';
import 'package:swasth_bharat/features/home/screens/home_screen.dart';
import 'package:swasth_bharat/providers/user_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  //idhar me saaare pages le aaya

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userfavouriteLen =
        context.watch<UserProvider>().user.favourites?.length;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '',
          ),
          // CART
          // BottomNavigationBarItem(
          //   icon: Container(
          //     width: bottomBarWidth,
          //     decoration: BoxDecoration(
          //       border: Border(
          //         top: BorderSide(
          //           color: _page == 2
          //               ? GlobalVariables.selectedNavBarColor
          //               : GlobalVariables.backgroundColor,
          //           width: bottomBarBorderWidth,
          //         ),
          //       ),
          //     ),
          //     child: badges.Badge(
          //       badgeStyle: const badges.BadgeStyle(
          //         elevation: 0,
          //         badgeColor: Colors.white,
          //       ),
          //       badgeContent: Text(userfavouriteLen.toString()),
          //       child: const Icon(
          //         Icons.shopping_cart_outlined,
          //       ),
          //     ),
          //   ),
          //   label: '',
          // ),
        ],
      ),
    );
  }
}
