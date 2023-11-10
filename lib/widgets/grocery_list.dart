import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app_00/data/categories.dart';
import 'package:shop_app_00/models/grocery_item.dart';
import 'package:shop_app_00/widgets/new_item.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Item Added Yet"),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (_) {
                _removeItem(_groceryItems[index]);
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
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    var url = Uri.https("flutter-test-c119c-default-rtdb.firebaseio.com",
        "shopping-list/${item.id}.json");
    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("We Could Not Delete The Item")));
      setState(() {
        _groceryItems.insert(index, item);
      });
      return;
    }

    if(json.decode(res.body) == null)
      {
        setState(() {
          _isLoading = false;
        });
        return;
      }

  }

  void _loadData() async {
    var url = Uri.https(
        "flutter-test-c119c-default-rtdb.firebaseio.com", "shopping-list.json");

      try{
        final http.Response res = await http.get(url);
        if (res.statusCode >= 404) {
          setState(() {
            _error = "Failed to fetch data. Please try again later!!";
          });
        }
        final Map<String, dynamic> loadedData = json.decode(res.body);
        final List<GroceryItem> loadedItems = [];
        for (var item in loadedData.entries) {
          final Category category = categories.entries
              .firstWhere(
                (element) => element.value.title == item.value['category'],
          )
              .value;

          loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category,
          ));
          setState(() {
            _groceryItems = loadedItems;
            _isLoading = false;
          });
        }
      }
      catch(err)
    {
      setState(() {
        _error = "Something Went Wrong. Please try again later!!";
      });
    }


  }

  _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }
}
