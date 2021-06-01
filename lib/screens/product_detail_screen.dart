import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    final PreferredSizeWidget appBar = AppBar(
      title: Text(loadedProduct.title),
      brightness: Brightness.dark,
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.45,
              width: double.infinity,
              child: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Price \$${loadedProduct.price}',
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${loadedProduct.description}',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
