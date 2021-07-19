import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Product with ChangeNotifier {
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourtie = false});
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourtie;

  Future<void> toggleFavourtieStatus(String authToken , String userid)async {
    final oldStatus = isFavourtie;
    isFavourtie = !isFavourtie;
    notifyListeners();
    print(userid);
    final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/userFavourites/$userid/$id.json?auth=$authToken');
    try{
      final response= await http.put(url,
      body: json.encode(
        isFavourtie,
      )
      );
      if(response.statusCode>=400){
        isFavourtie=oldStatus;
        notifyListeners();
      }
    }catch(e){
         isFavourtie=oldStatus;
        notifyListeners();
      }
  }

  
}
