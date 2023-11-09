import 'dart:convert';


import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shop_app_00/models/category.dart';
import 'package:shop_app_00/models/grocery_item.dart';


import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";
  int _enteredQuantity = 0;
  Category _selectedCategory = categories[Categories.fruit]!;
  bool _isLoading = false;

  void _saveItem()
  {
    if(_formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
     setState(() {
       _isLoading = true;
     });
      var url = Uri.https("flutter-test-c119c-default-rtdb.firebaseio.com","shopping-list.json");
      http.post(url,headers: {
        "content-type":"application/json"
      },body: json.encode(
          {
            "name":_enteredName,
            "quantity":_enteredQuantity,
            "category":_selectedCategory.title
          }
      ),).then((res) {
        final Map<String,dynamic> resData = json.decode(res.body);
        if(res.statusCode== 200)
        {
          Navigator.of(context).pop(
              GroceryItem(
                id: resData["name"],
                name: _enteredName,
                quantity: _enteredQuantity,
                category: _selectedCategory,
              )
          );
        }
      });


    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                maxLength: 50,
                onSaved: (newValue)
                {
                  _enteredName = newValue!;
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50)
                    {
                      return "Must be between 1 and 50 characters";
                    }
                    return null;
                },
          ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Quantity",
                        ),
                        initialValue: "1",
                        onSaved: (newValue)
                        {
                          _enteredQuantity = int.parse(newValue!);
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value)==null ||
                              int.tryParse(value)! <= 0)
                          {
                            return "Must be a valid positive number";
                          }
                          return null;
                        },
                      ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for(final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(width: 6,),
                                    Text(category.value.title),
                                  ],
                                ),
                            ),
                        ],
                        onChanged: (value){
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: _isLoading ? null:(){
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset")
                ),
                ElevatedButton(
                    onPressed: _isLoading? null: _saveItem,
                    child: _isLoading? const SizedBox(height:16, width:16,child: CircularProgressIndicator(),): const Text("Add Item")
                )
              ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
