import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import "package:shop_app/screens/product_detail_screen.dart";
import 'package:shop_app/screens/userproduct_screen.dart';
import 'providers/products_provider.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Products()),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProvider.value(value: Orders()),
          ChangeNotifierProvider.value(value: Auth())
        ],
        child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
         
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: AuthScreen(),
        routes: {
          ProductDetialScreen.routeName: (ctx)=> ProductDetialScreen(),
          CartScreen.nameRoute:(ctx)=> CartScreen(),
          OrdersScreen.routeName: (ctx)=> OrdersScreen(),
          UserProductsScreen.routeName: (ctx)=> UserProductsScreen(),
          EditProductScreen.routeName: (ctx)=> EditProductScreen(),
          AuthScreen.routeName : (ctx)=> AuthScreen(),
          ProductsOverviewScreen.routeName:(ctx)=> ProductsOverviewScreen(),
        },
      ),
    );
  }
}

