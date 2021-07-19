import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
    {
     @required this.id,
     @required this.amount,
     @required this.products,
     @required this.dateTime,
    }
  );
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders=[];

  List<OrderItem> get orders{
    return [..._orders];
  }
   String authToken;
   String userId;
  update(String token,String uid){
    authToken = token;
    userId = uid;
  }
 Future <void> addOrder(List<CartItem> cartProducts,double total)async{
    final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
   final response = await http.post(url,
    body: json.encode(
      {
        'amount':total,
        'dateTime':timestamp.toIso8601String(),
        'products': cartProducts.map((cp) => {
          'id':cp.id,
          'title':cp.title,
          'quantity':cp.quantity,
          'price':cp.price
        }).toList()

      }
    )
    );
    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: timestamp,
      products: cartProducts,
    ));
    notifyListeners();
  }
  Future<void> getOrder()async{
    final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    // print(response.body);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String,dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId, order) {
      loadedOrders.add(
        OrderItem(
          
          id: orderId,
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          products: List<CartItem>.from((order['products'] as List).map((item) => CartItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity'],
          )))

        ),
        
      );
      
     });
     _orders=loadedOrders.reversed.toList();
     notifyListeners();
  }
}