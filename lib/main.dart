import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider Class
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

// Screens
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './screens/orders_screen.dart';
import './screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProducts) => Products(
            auth.token,
            auth.userId,
            prevProducts == null ? [] : prevProducts.getAllProducts,
          ),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrders) => Orders(
            auth.token,
            auth.userId,
            prevOrders == null ? [] : prevOrders.getAllOrders,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth
            ? ProductsOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authDataSnapshot) =>
                    authDataSnapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
        debugShowCheckedModeBanner: false,
        routes: {
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
