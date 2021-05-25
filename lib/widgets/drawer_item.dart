import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String routeName;

  DrawerItem(this.title, this.icon, this.routeName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(icon),
            title: Text(title),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(routeName);
            },
          )
        ],
      ),
    );
  }
}
