import 'package:flutter/material.dart';
import 'package:location_sharing_app/navigation/routes.dart';
import 'package:location_sharing_app/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 20,
                        offset: Offset(0, 5))
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Colors.pink,
                      Colors.orange,
                    ],
                  )),
              child: const Text("Hello Isobel!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [smallCard(), smallCard()],
          ),
        ],
      ),
      bottomNavigationBar:
          // Container(
          //   child: PersistentTabView(
          //     context,
          //     controller: _controller,
          //     screens: _buildScreens(),
          //     items: _navBarsItems(),
          //     confineInSafeArea: true,
          //     backgroundColor: Colors.white, // Default is Colors.white.
          //     handleAndroidBackButtonPress: true, // Default is true.
          //     resizeToAvoidBottomInset:
          //         true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          //     stateManagement: true, // Default is true.
          //     hideNavigationBarWhenKeyboardShows:
          //         true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          //     decoration: NavBarDecoration(
          //       borderRadius: BorderRadius.circular(10.0),
          //       colorBehindNavBar: Colors.white,
          //     ),
          //     popAllScreensOnTapOfSelectedTab: true,
          //     popActionScreens: PopActionScreensType.all,
          //     itemAnimationProperties: const ItemAnimationProperties(
          //       // Navigation Bar's items animation properties.
          //       duration: Duration(milliseconds: 200),
          //       curve: Curves.ease,
          //     ),
          //     screenTransitionAnimation: const ScreenTransitionAnimation(
          //       // Screen transition animation on change of selected tab.
          //       animateTabTransition: true,
          //       curve: Curves.ease,
          //       duration: Duration(milliseconds: 200),
          //     ),
          //     navBarStyle: NavBarStyle
          //         .style1, // Choose the nav bar style with this property.
          //   ),
          // )
          BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomBarButton('Home', Icons.home, 30, () {
                Navigator.of(context).pushNamed(Routes.HOME);
              }, true),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.deepOrange,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              _bottomBarButton('Map', Icons.map, 30, () {
                Navigator.of(context).pushNamed(Routes.MAP);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Column _bottomBarButton(
      String text, IconData icon, double iconSize, Function action,
      [bool selected = false]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            action.call();
          },
          icon: Icon(
            icon,
            size: iconSize,
            color: selected ? Colors.black87 : Colors.grey,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: selected ? Colors.black87 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget smallCard() {
    return Container(
        height: 100,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 20,
                  offset: const Offset(0, 5))
            ],
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Colors.pink,
                Colors.orange,
              ],
            )),
        child: const Text("Hello Isobel!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16)));
  }
}
