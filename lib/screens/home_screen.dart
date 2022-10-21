import 'package:flutter/material.dart';
import 'package:location_sharing_app/navigation/routes.dart';
import 'package:location_sharing_app/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: _buildScreenWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 30,
        ), //icon inside button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomBarButton('Home', Icons.home, 30, () {}, true),
              _bottomBarButton('Map', Icons.map, 30, () {
                Navigator.of(context)
                    .pushNamed(Routes.MAP, arguments: username);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenWidget() {
    return Column(
      children: [
        _currentAppointmentCard(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [smallCard(), smallCard()],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Appointments',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 16),
              ),
            )
          ],
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text('Today',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                ),
                _recentAppointmentCard(),
                _recentAppointmentCard(),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text('Yesterday',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                ),
                _recentAppointmentCard(),
                _recentAppointmentCard(),
                _recentAppointmentCard(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _currentAppointmentCard() {
    return Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 20,
                  offset: const Offset(0, 5))
            ],
            gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Colors.pink,
                Colors.orange,
              ],
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "Upcoming Appointment",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "123 Street Address drive",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "123 Street Address drive",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ));
  }

  Container _recentAppointmentCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.orange,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    )),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      '11:25 AM',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Honda CRV',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Collected',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Jim Jacobs',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          )
        ],
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
        child: const Text("Hello There!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16)));
  }
}
