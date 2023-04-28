import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveList(List<String> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(list);
  await prefs.setString('list', jsonString);
}
Future<List<String>> getList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString('list') ?? '';
  List<String> list = List<String>.from(jsonDecode(jsonString));
  return list;
}
void main() {
  runApp(MaterialApp(
    home: Container(
      child: UserInputList(),
    ),
  ));
}

class UserInputList extends StatefulWidget {
  @override
  _UserInputListState createState() => _UserInputListState();

}

class _UserInputListState extends State<UserInputList> {
  final TextEditingController _controller = TextEditingController();
  List<String> items = [];
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    items = await getList();
    setState(() {});
  }
  void _saveItems() async {
    await saveList(items);
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Hot Wheels Collection',
      home: Scaffold(
      appBar: AppBar(
        title: const Text('Hot Wheels Collection'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(items),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter A Car',
            ),
          ),
          ElevatedButton(
            child: const Text('Add car'),
            onPressed: () {
              setState(() {
                String item = _controller.text;
                items.add(_controller.text);
                _controller.clear();
                _saveItems(); // Save the updated list
              });
            },
          ),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'Add new category',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                categories.add(_categoryController.text);
              });
              _categoryController.clear();
            },
            child: Text('Add'),
          ),
            Expanded(
              child: ListView.builder(
                 itemCount: items.length,
                  itemBuilder: (context, index) {
                  final item = items[index];
                  final category = categories[index % categories.length];
                     return Dismissible(
                       key: Key(item),
                        onDismissed: (direction) {
                        setState(() {
                          items.removeAt(index);
                          _saveItems(); // Save the updated list
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index % categories.length == 0) ...[
                          SizedBox(height: 8),
                          Text(category,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                        ListTile(
                          title: Text(item),
                          onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondRoute(item: item),
                            ),
                          ).then((editedItem) {
                            setState(() {
                            items[index] = editedItem;
                            _saveItems(); // Save the updated list
                           });
                       });
                    },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                             Navigator.push(
                               context,
                                MaterialPageRoute(
                                  builder: (context) => SecondRoute(item: item),
                                ),
                              ).then((editedItem) {
                                 setState(() {
                                  items[index] = editedItem;
                                  _saveItems(); // Save the updated list
                                });
                              });
                            },
                          ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  items.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      )
                  ] 
                );
                )
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<String> items;

  CustomSearchDelegate(this.items);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? items
        : items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            close(context, suggestions[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Not used here, but you could build search results
    return Container();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [      IconButton(        icon: Icon(Icons.clear),        onPressed: () {          query = '';        },      ),    ];
  }

  @override
  String get searchFieldLabel => 'Search items...';
}

class SecondRoute extends StatefulWidget {
  final String item;
  SecondRoute({required this.item});

    @override
  _SecondRouteState createState() => _SecondRouteState();
}
class _SecondRouteState extends State<SecondRoute> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.item;
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a Car',
            ),
          ),
          ElevatedButton(
            child: const Text('Save Changes'),
            onPressed: () {
              String editedItem = _controller.text;
              Navigator.pop(context, editedItem);
            },
          ),
        ],
      ),
    );
  }
}