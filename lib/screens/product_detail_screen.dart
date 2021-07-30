import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetialScreen extends StatelessWidget {
  // final String title;
  // ProductDetialScreen(this.title);
  static const routeName = '/produt-detail';

  @override
  Widget build(BuildContext context) {
   final productid= ModalRoute.of(context).settings.arguments as String;
   final product = Provider.of<Products>(context, listen: false).findById(productid);
    return Scaffold(
      appBar: AppBar(title: Text(product.title),),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(product.imageUrl,fit:BoxFit.cover)
          ),
          SizedBox(height:10),
          Text('₹${product.price}',
            style: TextStyle(
            color: Colors.grey,
            fontSize: 20
            ),
          ),
          SizedBox(height:10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal:10),
            child: Text(
              product.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  } 
}