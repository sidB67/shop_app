import 'package:flutter/material.dart';
import 'package:shop_app/Models/http_exception.dart';
import 'products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Products with ChangeNotifier{
  
  List<Product> _items=[


  ];
  

  List<Product> get items{
    
    return [..._items];
  }

  List<Product> get favItems{
    return _items.where((product)=>product.isFavourtie==true).toList();
  }

  Future<void> addProduct(Product product)async{
    final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/products.json');
    try{
      final response =  await http.post(url,
        body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavourite': product.isFavourtie,
    })
    );
      final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
    }catch(e){
      print(e.toString());
      throw e;
    }
   
    
    
    
  }

  Product findById(String id){
    return _items.firstWhere((element) => element.id== id);
  }
  Future<void> updateProduct(String id, Product editProduct)async{
    final prodIndex = _items.indexWhere((element) => element.id==id);
    if(prodIndex>=0){
      final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,body: json.encode(
        {
      'title': editProduct.title,
      'description': editProduct.description,
      'imageUrl': editProduct.imageUrl,
      'price': editProduct.price,
      
        }
      ));
      _items[prodIndex]=editProduct;
    notifyListeners();
    }else{
      print('...');
    }
  }
  Future<void> deleteProduct(String id)async{
     final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/products/$id.json');
     final existingProductIndex= _items.indexWhere((element) => element.id==id);
     var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id==id);
    notifyListeners();
    final response = await http.delete(url);
       if(response.statusCode>=400){
       _items.insert(existingProductIndex, existingProduct);
       notifyListeners();
        throw HttpException('Could not delete Product');
       }
       existingProduct=null;
    
    
      
    
   
  }

  Future<void> getProducts() async{
    final url = Uri.parse('https://shopapp-e35ae-default-rtdb.firebaseio.com/products.json');
    try{
      var response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String,dynamic>;
      final List<Product> loadedProducts=[];
      extractData.forEach((prodId, prodData) { 
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourtie: prodData['isFavourite'],
          imageUrl: prodData['imageUrl'],
        ));

      }
      
      );
    _items=loadedProducts;
    notifyListeners();
    }catch(error){
      throw error;
    }

  }
}