import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portrait_click/colors.dart';
import 'package:portrait_click/provider/user_provider.dart';
import 'package:portrait_click/screens/add_image_screen.dart';
import 'package:portrait_click/screens/chats/message_screen.dart';
import 'package:portrait_click/screens/homescreen.dart';
import 'package:portrait_click/screens/profilescreen.dart';
import 'package:portrait_click/screens/search_screen.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<Widget> bottomNavigationItems = [
      const HomeScreen(),
      const SearchScreen(),
      const AddImageScreen(),
      const MessageScreen(),
      ProfileScreen(
        uid: userProvider.getUser.uid,
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: bottomNavigationItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bgColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: (_page == 0) ? blueColor : secondaryColor,
            ),
            label: 'Home',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: (_page == 1) ? blueColor : secondaryColor,
              ),
              label: 'Search',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                color: (_page == 2) ? blueColor : secondaryColor,
              ),
              label: 'Add',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: FaIcon(
              (_page == 3)
                  ? FontAwesomeIcons.solidMessage
                  : FontAwesomeIcons.message,
              color: (_page == 3) ? blueColor : secondaryColor,
            ),
            label: 'Chats',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              (_page == 4) ? FontAwesomeIcons.solidUser : FontAwesomeIcons.user,
              color: (_page == 4) ? blueColor : secondaryColor,
            ),
            label: 'Profile',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
