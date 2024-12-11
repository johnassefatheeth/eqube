import 'package:flutter/material.dart';

class DrawerList extends StatefulWidget {
  const DrawerList({super.key});

  @override
  State<DrawerList> createState() => _DrawerListState();
}

/// Represents a custom drawer menu list.
///
/// This widget displays a list of menu items in a column format within a container.
/// Each menu item is created using the [menuItem] method.
class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem("home", Icons.home),
          menuItem("my_ekub", Icons.plus_one_outlined),
          menuItem("profile", Icons.man),
          menuItem("changepassword", Icons.key),
          menuItem("contactus", Icons.phone)
        ],
      ),
    );
  }

   /// Creates a menu item with the specified [title] and [icon].
  ///
  /// When the menu item is tapped, it navigates to the corresponding route
  /// based on the [title]. If the title is "ማስተካከያ", it navigates to '/settings'.
  /// If the title is "የኔ ኣካውንት", it navigates to '/myprofile'. Otherwise, it
  /// navigates to '/$title'.
  ///
  /// Parameters:
  /// - [title]: The title of the menu item.
  /// - [icon]: The icon associated with the menu item.
  ///
  /// Returns:
  /// A material-based InkWell widget representing the menu item.

  Widget menuItem(String title, IconData icon) {
  return Material(
    child: InkWell(
      onTap: () {
        if(title=='ማስተካከያ')
        Navigator.pushNamed(context, '/settings');
        if(title=='የኔ ኣካውንት')
        Navigator.pushNamed(context, '/myprofile');
        if(title=='my_ekub')
        Navigator.pushNamed(context, '/my_ekub');
        else
        Navigator.pushNamed(context, '/$title');

      },
      child: Padding(
        padding:const EdgeInsets.only(top:15.0,bottom: 15,left: 30),
        child: Row(
          children: [
            Icon(icon,),
            const SizedBox(width: 8), // Adding space between icon and text
            Expanded(
              child: Text(
                title,
                style:const TextStyle(fontSize: 16), // Adjust text size as needed
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}