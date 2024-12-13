import 'package:flutter/material.dart';

class DrawerHeaderpart extends StatefulWidget {
  const DrawerHeaderpart({super.key});

  @override
  State<DrawerHeaderpart> createState() => _DrawerHeaderpartState();
}

class _DrawerHeaderpartState extends State<DrawerHeaderpart> {
  @override
  //build method
  Widget build(BuildContext context) {
    // continer widget
    return Container(
      color:  Colors.teal,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   margin: EdgeInsets.only(bottom: 10),
          //   height: 70,
          //   decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       image: DecorationImage(
          //           image: NetworkImage(
          //               'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQubUz3YKP7UQO_YFz5IQ1J4ou7sbDXAoy-40_eHoRTdA&s'))),
          // ),
          const Text(
            'User Name',
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
