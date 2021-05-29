import 'package:flutter/cupertino.dart';
class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    this.id,
    this.title,
    this.quantity,
    this.price,
  });
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _items={};

  Map<String,CartItem> get items{
    return {..._items};
  }

  void addItem(String productID,double price,String title){
    if(_items.containsKey(productID)){
      _items.update(productID, (value) => 
        CartItem(
          id: value.id, title: value.title, price: value.price,
          quantity: value.quantity+1
        )
      );
    }else{
      _items.putIfAbsent(productID, () => 
      CartItem(id:DateTime.now().toString(),
      title: title, 
      price: price,
      quantity: 1
      ));
      notifyListeners();
    }
  }
  int get itemCount {
    return _items.length;

  }
  double get totalAmount{
    var total=0.0;
    _items.forEach((key, cartItem) {
      total = cartItem.quantity*cartItem.price;
    }
    
    );
    return total;
  }
  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }
  void clear(){
    _items={};
    notifyListeners();
  }
  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return ;
    }
    if(_items[productId].quantity>1){
      _items.update(productId, (existingCartItem) => 
        CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity-1
        )
      );
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
}