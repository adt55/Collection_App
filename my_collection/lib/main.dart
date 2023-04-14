import 'package:flutter/material.dart';

void main() {
  runApp(UserInputList());
}

class UserInputList extends StatefulWidget {
  @override
  _UserInputListState createState() => _UserInputListState();
}
/*  class Category {
  String name;
  List<String> items;

  Category(this.name, this.items);
} */
class _UserInputListState extends State<UserInputList> {
  final TextEditingController _controller = TextEditingController();
  final List<String> items = [];
  // final List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Hot WHeels Collection',
      home: Scaffold(
      appBar: AppBar(
        title: const Text('Hot Wheels Collection'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
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
/*                 Category category = categories.firstWhere((c) => c.name == item);
                  if (category == null) {
                    category = Category(item, []);
                    categories.add(category);
                  }
                  category.items.add(item); */
              });
            },
          ),
/*                       Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, categoryIndex) {
                  Category category = categories[categoryIndex];
                  return ExpansionTile(
                    title: Text(category.name),
                    children: category.items.map((item) => ListTile(
                      title: Text(item),
                    )).toList(),
                  );
                },
              ),
                      ), */
                      Expanded(
              child: ListView.builder(
                 itemCount: items.length,
                  itemBuilder: (context, index) {
                  final item = items[index];
                     return Dismissible(
                    key: Key(item),
           onDismissed: (direction) {
          setState(() {
            items.removeAt(index);
          });
        },
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
            },
          ),
        ),
      );
    },
  ),
),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ],
      ),
      )
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<String> items;

  CustomSearchDelegate(this.items);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
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
