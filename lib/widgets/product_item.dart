import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
          child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(
            ProductDetialScreen.routeName,
            arguments: productData.id
            );
          },
                  child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>( // here with help of consumer we are now only reubuilding part of widget i.e. the fav button
            builder: (ctx,productData,_)=>
                       IconButton(
              icon: Icon(productData.isFavourtie? Icons.favorite:Icons.favorite_border),
              onPressed: () {
                productData.toggleFavourtieStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(productData.id, productData.price, productData.title );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart'),
                  duration: Duration(seconds:2),
                  action: SnackBarAction(
                    label: 'UNDO', 
                    onPressed: (){
                      cart.removeSingleItem(productData.id);
                    }
                    ),
                )
              );
            },
            color: Theme.of(context).accentColor
          ),
        ),
      ),
    );
  }
}
