import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';
import '../screens/product_detail_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        brightness: Brightness.dark,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.getAllProducts.length,
          itemBuilder: (_, i) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: products.getAllProducts[i].id,
                  );
                },
                child: UserProduct(
                  products.getAllProducts[i].id,
                  products.getAllProducts[i].title,
                  products.getAllProducts[i].imageUrl,
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
