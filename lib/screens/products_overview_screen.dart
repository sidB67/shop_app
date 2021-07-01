import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
enum FilterOption {
  Favourite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    
    super.initState();
  }
@override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<Products>(context).getProducts().then((value){
          setState(() {
        _isLoading = false;
      });
      });
    }
    _isInit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                if (selectedValue == FilterOption.Favourite) {
                  setState(() {
                    _showOnlyFavourites = true;
                  });
                } else {
                  setState(() {
                    _showOnlyFavourites = false;
                  });
                }
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only Favourties'),
                        value: FilterOption.Favourite),
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOption.All),
                  ]),
          Consumer<Cart>(
            builder: (context,cartData,ch)=>
                       Badge(
                child: ch,
                value: cartData.itemCount.toString()),
                child:IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: (){
                    Navigator.of(context).pushNamed(CartScreen.nameRoute);
                  },
                ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading?Center(
        child: CircularProgressIndicator()
      ) :ProductsGrid(_showOnlyFavourites),
    );
  }
}
