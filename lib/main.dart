import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListSelectionScreen(),
    );
  }
}

class ListSelectionScreen extends StatefulWidget {
  @override
  _ListSelectionScreenState createState() => _ListSelectionScreenState();
}

class _ListSelectionScreenState extends State<ListSelectionScreen> {
  List<String> _lists = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lists = prefs.getStringList('shopping_lists') ?? [];
    });
  }

  Future<void> _saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('shopping_lists', _lists);
  }

  void _createNewList() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _lists.add(_controller.text);
        _controller.clear();
        _saveLists();
      });
    }
  }

  void _removeList(int index) {
    setState(() {
      _lists.removeAt(index); // Remove a lista
      _saveLists(); // Salva novamente a lista atualizada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Listas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Nome da nova lista',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _createNewList,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _lists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_lists[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeList(index), // Exclui a lista
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShoppingListScreen(listName: _lists[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  final String listName;
  ShoppingListScreen({required this.listName});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<String> _items = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList(widget.listName) ?? [];
    });
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(widget.listName, _items);
  }

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(_controller.text);
        _controller.clear();
        _saveItems();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _saveItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.listName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Novo item',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
