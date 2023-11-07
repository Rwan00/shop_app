import 'package:flutter/material.dart';

import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
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
                    onPressed: (){
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset")
                ),
                ElevatedButton(
                    onPressed: (){
                      _formKey.currentState!.validate();
                    },
                    child: const Text("Add Item")
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
