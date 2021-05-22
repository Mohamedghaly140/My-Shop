import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        brightness: Brightness.dark,
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.getAllOrders.length,
        itemBuilder: (ctx, i) => OrderItem(orders.getAllOrders[i]),
      ),
    );
  }
}
