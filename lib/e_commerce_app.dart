// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';


// class Product {
//   final int id;
//   final String name;
//   final double price;

//   Product({required this.id, required this.name, required this.price});
// }

// class ProductListScreen extends StatelessWidget {
  
//   final List<CartItem> cartItems; // Add this line

//   ProductListScreen({required this.products, required this.cartItems}); // Add this constructor

//    List<Product> products = [
//     Product(id: 1, name: 'Product A', price: 10.0),
//     Product(id: 2, name: 'Product B', price: 20.0),
//     Product(id: 3, name: 'Product C', price: 15.0),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_cart),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => CartScreen(cartItems: [],)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return ListTile(
//             title: Text('${product.name} (\$${product.price.toStringAsFixed(2)})'),
//             trailing: IconButton(
//               icon: Icon(Icons.add_shopping_cart),
//               onPressed: () {Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems, selectedProduct: product)),
// );

//                 // Add the product to the cart here
                
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class CartScreen extends StatefulWidget {
//   @override
//    final List<CartItem> cartItems;
//   final Product? selectedProduct;
//    CartScreen({required this.cartItems, this.selectedProduct});
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   // Databas=e helper
//   final CartDatabaseHelper cartDatabaseHelper = CartDatabaseHelper();

//   late List<CartItem> cartItems;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCart();
//   }

//   Future<void> _initializeCart() async {
//     await cartDatabaseHelper.initializeDatabase();
//     cartItems = await cartDatabaseHelper.getAllCartItems();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shopping Cart'),
//       ),
//       body: ListView.builder(
//         itemCount: cartItems.length,
//         itemBuilder: (context, index) {
//           final item = cartItems[index];
//           return ListTile(
//             title: Text('${item.productName} (\$${item.productPrice.toStringAsFixed(2)})'),
//             subtitle: Text('Quantity: ${item.quantity}'),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () async {
//                 await cartDatabaseHelper.deleteCartItem(item.id);
//                 _initializeCart();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ////////////////////////////////////
// class CartItem {
//   final int id;
//   final String productName;
//   final double productPrice;
//   final int quantity;

//   CartItem({
//     required this.id,
//     required this.productName,
//     required this.productPrice,
//     required this.quantity,
//   });
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'productName': productName,
//       'productPrice': productPrice,
//       'quantity': quantity,
//     };
//   }

//   factory CartItem.fromMap(Map<String, dynamic> map) {
//     return CartItem(
//       id: map['id'],
//       productName: map['productName'],
//       productPrice: map['productPrice'],
//       quantity: map['quantity'],
//     );
//   }

// }

// class CartDatabaseHelper {
//   static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();

//   factory CartDatabaseHelper() => _instance;

//   CartDatabaseHelper._internal();

//   late Database _database;

//   Future<void> initializeDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'cart.db');

//     _database = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute('''
//         CREATE TABLE CartItems (
//           id INTEGER PRIMARY KEY,
//           productName TEXT,
//           productPrice REAL,
//           quantity INTEGER
//         )
//       ''');
//     });
//   }

//   Future<void> insertCartItem(CartItem item) async {
//     await _database.insert('CartItems', item.toMap());
//   }

//   Future<void> updateCartItem(CartItem item) async {
//     await _database.update(
//       'CartItems',
//       item.toMap(),
//       where: 'id = ?',
//       whereArgs: [item.id],
//     );
//   }

//   Future<void> deleteCartItem(int id) async {
//     await _database.delete('CartItems', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<List<CartItem>> getAllCartItems() async {
//     final cartItems = await _database.query('CartItems');
//     return cartItems.map((item) => CartItem.fromMap(item)).toList();
//   }
  
//   Future<void> closeDatabase() async {
//     await _database.close();
//   }
// }

