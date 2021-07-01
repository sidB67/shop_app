import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/http_exception.dart';
import 'dart:convert';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email,String password) async{
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCl70sY4DgMGNAQLY7AylCQeGkCq5hBme8');
  try{
  final response = await http.post(url,body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken':true
    }
    )
   );
   final responseData = json.decode(response.body);
   if(responseData['error']!=null){
     throw HttpException(responseData['error']['message']);
   }
  
  }catch(error){
    throw error;
  }
  }
  Future<void> signIn(String email,String password) async{
     final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCl70sY4DgMGNAQLY7AylCQeGkCq5hBme8');
     try{
     final response = await http.post(url,body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken':true
    }) );
     final responseData = json.decode(response.body);
   if(responseData['error']!=null){
     throw HttpException(responseData['error']['message']);
   }
    }catch(error){
      throw error;
    }
   
  }
  
}