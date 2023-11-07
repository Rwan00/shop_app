import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Form(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
