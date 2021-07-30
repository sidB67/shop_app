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
import 'package:shop_app/screens/splash_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth,Products>(create: (ctx)=>Products(), update: (ctx,auth,prevData)=> prevData..update(auth.token ,auth.userId)),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth,Orders>(create: (ctx)=>Orders(), update: (ctx,auth,prevData)=> prevData..update(auth.token,auth.userId)),
          
        ],
        child: Consumer<Auth>(
          builder: (context,authData,_)=>
          MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
         
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: authData.isAuth ? ProductsOverviewScreen() :
        FutureBuilder(
          future: authData.tryAutoLogin(),
          builder: (ctx,authResultSnapshot)=>
          authResultSnapshot.connectionState == ConnectionState.waiting
          ? SplashScreen()
          : AuthScreen(),), 
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
        ),
    );
  }
}

