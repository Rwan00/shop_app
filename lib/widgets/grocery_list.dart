import 'package:flutter/material.dart';
import 'package:shop_app_00/models/grocery_item.dart';
import 'package:shop_app_00/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Item Added Yet"),
    );

    if(_groceryItems.isNotEmpty)
      {
        content = ListView.builder(
            itemCount: _groceryItems.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (_){
                  setState(() {
                    _groceryItems.remove(_groceryItems[index]);
                  });
                },
                child: ListTile(
                  title: Text(_groceryItems[index].name),
                  leading: Container(
                    height: 24,
                    width: 24,
                    color: _groceryItems[index].category.color,
                  ),
                  trailing: Text(_groceryItems[index].quantity.toString()),
                ),
              );
            });
      }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push<GroceryItem>(
                  MaterialPageRoute(
                    builder: (context) => const NewItem(),
                  ),
                ).then((GroceryItem? value) {
                  if(value == null)
                    {
                      return;
                    }
                  else{
                   setState(() {
                     _groceryItems.add(value);
                   });
                  }
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: content,
    );
  }
}
