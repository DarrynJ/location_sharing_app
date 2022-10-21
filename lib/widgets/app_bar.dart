import 'package:flutter/material.dart';
import 'package:location_sharing_app/screens/home_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<StatefulWidget> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        "We Track Cars",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        child:
            const Icon(Icons.home, color: Colors.white // add custom icons also
                ),
      ),
    );
  }
}
