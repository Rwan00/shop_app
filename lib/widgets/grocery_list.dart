import 'package:flutter/material.dart';
import 'package:shop_app_00/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
          itemBuilder: (context,index){
        return ListTile(
          title: Text(groceryItems[index].name),
          leading: Container(
            height: 24,
            width: 24,
            color: groceryItems[index].category.color,
          ),
          trailing: Text(groceryItems[index].quantity.toString()),
        );
      }),
    );
  }
}
