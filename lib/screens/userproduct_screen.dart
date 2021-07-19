import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).getProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    print('rebuilding ...');
  //  final productsData= Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],

      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx , snapshot)=> 
        snapshot.connectionState == ConnectionState.waiting? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: ()=>_refreshProducts(context) ,
                child: Consumer<Products>(
                  builder: (ctx , productsData,_)=>
                   Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (ctx,i){
                  return Column(
                    children: [
                      UserProductItem(
                        id: productsData.items[i].id,
                        title: productsData.items[i].title,
                        imageUrl: productsData.items[i].imageUrl,
                      ),
                      Divider()
                    ],
                  );
              }
              ),
          ),
                ),
        ),
      )
    );
  }
}