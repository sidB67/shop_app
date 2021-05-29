import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_)async{
      setState(() {
        isLoading = true;
      });
     await Provider.of<Orders>(context,listen: false).getOrder();
     setState(() {
       isLoading= false;
     });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData= Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: isLoading? Center(child: CircularProgressIndicator(),):ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (BuildContext context, int i) { 
          return OrderItem(orderData.orders[i]);
        }
      ),
    );
  }
}