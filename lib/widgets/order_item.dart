import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('₹${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(expanded?Icons.expand_less:Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
            
              Container(
                padding: EdgeInsets.symmetric(horizontal:15, vertical:4),
                height: min(widget.order.products.length * 20 + 10, 180)
                    .toDouble(),
                child: ListView(
                  children: widget.order.products.map((e) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(e.title, style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold)),
                    Text(
                      '${e.quantity}x₹${e.price}',
                      style: TextStyle(fontSize: 18,color: Colors.grey),
                    )
                  ],)
                  ).toList(),
                ),
              )
            
        ],
      ),
    );
  }
}
