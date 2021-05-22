import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';

import '../providers/cart.dart';

import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;

  void toggleFavorites(FilterOptions value) {
    setState(() {
      if (value == FilterOptions.Favorites) {
        _showFavoritesOnly = true;
      } else {
        _showFavoritesOnly = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        brightness: Brightness.dark,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              toggleFavorites(selectedValue);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
