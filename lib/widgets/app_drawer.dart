import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import './drawer_item.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            brightness: Brightness.dark,
            automaticallyImplyLeading: false,
          ),
          DrawerItem('Shop', Icons.shop, '/'),
          DrawerItem(
            'Orders',
            Icons.payment,
            OrdersScreen.routeName,
          ),
          DrawerItem(
            'Manage Products',
            Icons.edit,
            UserProductsScreen.routeName,
          ),
          Spacer(),
          Container(
            child: Column(
              children: [
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    auth.logout();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
