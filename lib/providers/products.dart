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

  Future<void> toggleFavourtieStatus()async {
    final oldStatus = isFavourtie;
    isFavourtie = !isFavourtie;
    notifyListeners();
    final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/products/$id.json');
    try{
      final response= await http.patch(url,
      body: json.encode({
        'isFavourite': isFavourtie
      })
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
