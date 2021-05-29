import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
class ProductsGrid extends StatelessWidget {
  

  final bool showFavs;
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
   final productsData = Provider.of<Products>(context);
   final loadedProduct = showFavs?productsData.favItems: productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProduct.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
                  value: loadedProduct[i],
                  child: ProductItem(
            // id:loadedProduct[i].id,
            // title: loadedProduct[i].title,
            // imageUrl: loadedProduct[i].imageUrl,
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          ),
    );
  }
}
