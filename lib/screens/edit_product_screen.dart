import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var isInit = true;
  var initValues={
    'title': '',
     'description':'',
     'price' : '',
     'imageURL': '',

  };
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if(isInit){

     final productId = ModalRoute.of(context).settings.arguments as String;
     if(productId!= null){
     final product =  Provider.of<Products>(context,listen: false).findById(productId);
      _editedProduct=product;
      initValues={
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        'imageURL': ''
      };
      _imageURLController.text= _editedProduct.imageUrl;
    }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);

    super.initState();
  }
  
  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if((!_imageURLController.text.startsWith('http')&&
        !_imageURLController.text.startsWith('https')) ||
       (!_imageURLController.text.endsWith('.png') &&
       !_imageURLController.text.endsWith('.jpg') &&
       !_imageURLController.text.endsWith('.jpeg') )
      ){
     
        return ; 
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.removeListener(_updateImageURL);
    _imageURLFocusNode.dispose();
    super.dispose();
  }

 Future <void> _saveForm()async {
    var isValid = _form.currentState.validate();
    if(!isValid){
      return ;
    }
    _form.currentState.save();
    setState(() {
      isLoading=true;
    });
    if(_editedProduct.id!=null){
     await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        isLoading=false;
      });
      Navigator.of(context).pop();
    }else{
      try{
     await Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
      }catch(error){
         await showDialog(context: context, 
        builder: (ctx)=> AlertDialog(
          title: Text('An error occured'),

          content: Text('Something went wrong'),
          actions: [
            TextButton(
              onPressed: (){Navigator.of(ctx).pop();}, 
            child: Text('Okay')
            )
          ],
        )
        );
      }finally{
        setState(() {
        isLoading=false;
      });
        Navigator.of(context).pop();
      }
      
        
     
      
      
    }
    
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: isLoading? Center(child: CircularProgressIndicator()): Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                initialValue: initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourtie: _editedProduct.isFavourtie,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return "This field cant be empty";
                  }
                  return null ;
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved:(value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourtie: _editedProduct.isFavourtie,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return "Plese enter a price ";
                  }
                  if(double.tryParse(value)==null){
                    return "Please enter a valid number";
                  }
                  if(double.parse(value)<=0){
                    return "Please Enter a number greater than 0";
                  }
                  return null;
                } ,
              ),
              TextFormField(
                initialValue: initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                 onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourtie: _editedProduct.isFavourtie,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return "Please enter a Description";
                  }
                  if(value.length<10){
                    return "Description is too short";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    )),
                    child: _imageURLController.text.isEmpty
                        ? Text('Enter a URL')
                        : Image.network(_imageURLController.text,
                            fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: TextFormField(
                     
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      focusNode: _imageURLFocusNode,
                      onEditingComplete: () {
                        _updateImageURL();
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                       onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourtie: _editedProduct.isFavourtie,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: value,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return "Please enter image URL";
                  }
                  if(!value.startsWith('http')&& !value.startsWith('https')){
                    return 'Please Enter a valid URL';
                  }
                  if(!value.endsWith('.png')&& !value.endsWith('jpg')&& !value.endsWith('.jpeg')){
                    return "Please enter valid image URL";
                  }
                  return null;
                },
                    ),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
