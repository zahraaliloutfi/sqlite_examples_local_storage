import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();

  final _cartItems = <CartItem>[];
  int _nextItemId = 1;

  late Database _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'cart.db');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE CartItems (
          id INTEGER PRIMARY KEY,
          name TEXT,
          price REAL,
          quantity INTEGER
        )
      ''');
    });

    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final cartItems = await _database.query('CartItems');
    setState(() {
      _cartItems.clear();
      _cartItems.addAll(cartItems.map((item) => CartItem.fromMap(item)));
    });
  }

  Future<void> _insertCartItem() async {
    final name = _itemNameController.text;
    final price = double.parse(_itemPriceController.text);
    final quantity = int.parse(_itemQuantityController.text);

    final newItem = CartItem(
      id: _nextItemId,
      name: name,
      price: price,
      quantity: quantity,
    );

    await _database.insert('CartItems', newItem.toMap());

    setState(() {
      _cartItems.add(newItem);
      _nextItemId++;
    });

    _itemNameController.clear();
    _itemPriceController.clear();
    _itemQuantityController.clear();
  }

  Future<void> _deleteCartItem(int id) async {
    await _database.delete('CartItems', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: _itemPriceController,
                  decoration: InputDecoration(labelText: 'Item Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _itemQuantityController,
                  decoration: InputDecoration(labelText: 'Item Quantity'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _insertCartItem,
                  child: Text('Add Item to Cart'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  title: Text('${item.name} (\$${item.price.toStringAsFixed(2)})'),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCartItem(item.id),
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

class CartItem {
  final int id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
