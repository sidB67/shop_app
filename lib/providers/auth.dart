import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/http_exception.dart';
import 'dart:convert';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  bool get isAuth{
      return token!=null;
  }

  String get token{
      if(_expiryDate !=null &&_expiryDate.isAfter(DateTime.now()) && _token!=null){
        return _token;
      }
      return null;
  }

  String get userId{
    return _userId;
  }

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
   _token = responseData['idToken'];
   _userId = responseData['localId'];
   _expiryDate = DateTime.now().add(Duration(
     seconds: int.parse(responseData['expiresIn'])));

    notifyListeners();
  
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
    _token = responseData['idToken'];
   _userId = responseData['localId'];
   _expiryDate = DateTime.now().add(Duration(
     seconds: int.parse(responseData['expiresIn'])));
    _autoLogout();
    notifyListeners();
    }catch(error){
      throw error;
    }
   
  }

  void logout(){
    _token = null;
    _userId = null;
    _expiryDate = null;
     if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
  
  void _autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
   _authTimer =Timer(Duration(seconds:timeToExpiry ), logout);
  }

}