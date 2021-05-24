import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        brightness: Brightness.dark,
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    child: Text('Order Now'),
                    onPressed: () {
                      if (cart.items.values.toList().length == 0) {
                        return null;
                      }
                      order.addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      // clear cart items
                      cart.clearCartItems();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: cart.items.values.toList().length == 0
                ? Center(
                    child: Text('You have no items in cart, maybe start added'),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, i) {
                      return CartItem(
                        cart.items.values.toList()[i].id,
                        cart.items.keys.toList()[i],
                        cart.items.values.toList()[i].title,
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                      );
                    },
                    itemCount: cart.itemsCount,
                  ),
          ),
        ],
      ),
    );
  }
}
