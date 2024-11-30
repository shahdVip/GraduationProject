import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/cart_item/cart_item_widget.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'cart_model.dart';
export 'cart_model.dart';

// class CartWidget extends StatefulWidget {
//   const CartWidget({super.key});

//   @override
//   State<CartWidget> createState() => _CartWidgetState();
// }

// class _CartWidgetState extends State<CartWidget> {
//   late CartModel _model;
//   late Future<List<Map<String, dynamic>>> cartItems;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   double totalPrice = 0.0;

//   late List<Map<String, dynamic>> items = []; // Initialize as an empty list

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => CartModel());
//     cartItems =
//         fetchCartDetails(); // Fetch cart details when the widget is initialized

//     WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   Future<void> removeItemFromCart(String itemName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? username = prefs
//         .getString('username'); // Retrieve username from shared preferences

//     if (username != null) {
//       try {
//         // Replace with your API URL
//         final response = await http.delete(
//           Uri.parse('$url/cart/remove/$username/$itemName'),
//           headers: {'Content-Type': 'application/json'},
//         );

//         if (response.statusCode == 200) {
//           print('Item removed from cart');
//           setState(() {
//             cartItems = fetchCartDetails(); // Refresh cart details
//           });
//         } else {
//           print('Failed to remove item from cart: ${response.body}');
//         }
//       } catch (e) {
//         print('Error removing item from cart: $e');
//       }
//     } else {
//       print('Username not found in shared preferences');
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchCartDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? username = prefs
//         .getString('username'); // Retrieve username from shared preferences

//     if (username != null) {
//       try {
//         // Replace with your API URL
//         final response = await http.get(
//           Uri.parse('$url/cart/$username'),
//           headers: {'Content-Type': 'application/json'},
//         );

//         if (response.statusCode == 200) {
//           final List<dynamic> cartItems = jsonDecode(response.body)['items'];
//           calculateTotalPrice(); // Recalculate total price after fetching

//           return cartItems.cast<Map<String, dynamic>>();
//         } else {
//           throw Exception('Failed to fetch cart: ${response.body}');
//         }
//       } catch (e) {
//         throw Exception('Error fetching cart: $e');
//       }
//     } else {
//       throw Exception('Username not found in shared preferences');
//     }
//   }

//   void calculateTotalPrice() async {
//     final items = await cartItems; // Wait for the cart items
//     if (items != null) {
//       double newTotalPrice = 0.0;
//       for (var item in items) {
//         final price = item['price'] ?? 0; // Default price 0
//         final quantity = item['quantity'] ?? 0; // Default quantity 0
//         newTotalPrice += price * quantity;
//       }
//       setState(() {
//         totalPrice = newTotalPrice; // Update the total price in state
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Scaffold(
//             key: scaffoldKey,
//             backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//             appBar: AppBar(
//               backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//               automaticallyImplyLeading: false,
//               leading: FlutterFlowIconButton(
//                 borderRadius: 8,
//                 buttonSize: 40,
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: FlutterFlowTheme.of(context).primary,
//                   size: 24,
//                 ),
//                 onPressed: () async {
//                   context.safePop();
//                 },
//               ),
//               title: Text(
//                 'My Cart',
//                 style: FlutterFlowTheme.of(context).displaySmall.override(
//                       fontFamily: 'Funnel Display',
//                       color: FlutterFlowTheme.of(context).primary,
//                       letterSpacing: 0.0,
//                       useGoogleFonts: false,
//                     ),
//               ),
//               actions: [],
//               centerTitle: false,
//               elevation: 0,
//             ),
//             body: Column(mainAxisSize: MainAxisSize.max, children: [
//               Expanded(
//                   child: Container(
//                 decoration: BoxDecoration(),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
//                         child: Text(
//                           'Below are the items in your cart.',
//                           style:
//                               FlutterFlowTheme.of(context).labelMedium.override(
//                                     fontFamily: 'Funnel Display',
//                                     letterSpacing: 0.0,
//                                     useGoogleFonts: false,
//                                   ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                         child: FutureBuilder<List<Map<String, dynamic>>>(
//                             future: cartItems,
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Center(
//                                     child: CircularProgressIndicator());
//                               } else if (snapshot.hasError) {
//                                 return Center(
//                                     child: Text('Error: ${snapshot.error}'));
//                               } else if (!snapshot.hasData ||
//                                   snapshot.data!.isEmpty) {
//                                 return Center(
//                                     child: Text('Your cart is empty.'));
//                               } else {
//                                 items = snapshot.data!;

//                                 double totalPrice = 0.0;

//                                 // Calculate the total price
//                                 for (var item in items) {
//                                   final price =
//                                       item['price'] ?? 0; // Default price 0
//                                   final quantity = item['quantity'] ??
//                                       0; // Default quantity 0
//                                   totalPrice += price * quantity;
//                                 }
//                                 print(totalPrice);
//                                 return Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     ListView.builder(
//                                       padding: EdgeInsets.zero,
//                                       primary: false,
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.vertical,
//                                       itemCount: items.length,
//                                       itemBuilder: (context, index) {
//                                         final item = items[index];
//                                         print(
//                                             'itemmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm: $item');
//                                         // Provide default values if any data is null
//                                         final itemName = item['name'] ??
//                                             'Unnamed Item'; // Default value
//                                         final itemPrice = (item['price'] ?? 0)
//                                             .toString(); // Convert to String

//                                         final itemPhoto = item['photo'] ??
//                                             ''; // Default empty string
//                                         // final itemId = item['_id'] ??
//                                         //     ''; // Default empty string
//                                         final itemQuantity = item['quantity'] ??
//                                             0; // Default value (0)

//                                         return CartItemWidget(
//                                           itemName: itemName,
//                                           itemPrice: itemPrice,
//                                           itemPhoto: itemPhoto,
//                                           quantity: itemQuantity,
//                                           //itemId: itemId,
//                                           fetchCartDetails:
//                                               fetchCartDetails, // Pass the callback
//                                           removeItemFromCart:
//                                               removeItemFromCart, // Pass the function
//                                         );
//                                       },
//                                     )
//                                   ],
//                                 );
//                               }
//                             }),
//                       ),
//                       Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
//                         child: Container(
//                           decoration: BoxDecoration(),
//                           child: Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(24, 10, 24, 12),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Total',
//                                   style: FlutterFlowTheme.of(context)
//                                       .displaySmall
//                                       .override(
//                                         fontFamily: 'Funnel Display',
//                                         letterSpacing: 0.0,
//                                         useGoogleFonts: false,
//                                       ),
//                                 ),
//                                 Text(
//                                   '\$${totalPrice.toStringAsFixed(2)}',
//                                   style: FlutterFlowTheme.of(context)
//                                       .displaySmall
//                                       .override(
//                                         fontFamily: 'Funnel Display',
//                                         letterSpacing: 0.0,
//                                         useGoogleFonts: false,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           color: FlutterFlowTheme.of(context).secondary,
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 4,
//                               color: Color(0x320E151B),
//                               offset: Offset(
//                                 0.0,
//                                 -2,
//                               ),
//                             )
//                           ],
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(0),
//                             bottomRight: Radius.circular(0),
//                             topLeft: Radius.circular(12),
//                             topRight: Radius.circular(12),
//                           ),
//                         ),
//                         alignment: AlignmentDirectional(0, 0),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
//                           child: Text(
//                             'Checkout ',
//                             style: FlutterFlowTheme.of(context)
//                                 .titleMedium
//                                 .override(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                   fontFamily: 'Funnel Display',
//                                   letterSpacing: 0.0,
//                                   useGoogleFonts: false,
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ))
//             ])));
//   }
// }

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late CartModel _model;

  late Future<List<Map<String, dynamic>>> cartItems;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double totalPrice = 0.0;

  late List<Map<String, dynamic>> items = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartModel());
    cartItems =
        fetchCartDetails(); // Fetch cart details when the widget is initialized

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> removeItemFromCart(String itemName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs
        .getString('username'); // Retrieve username from shared preferences

    if (username != null) {
      try {
        // Replace with your API URL
        final response = await http.delete(
          Uri.parse('$url/cart/remove/$username/$itemName'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          print('Item removed from cart');
          setState(() {
            cartItems = fetchCartDetails(); // Refresh cart details
          });
        } else {
          print('Failed to remove item from cart: ${response.body}');
        }
      } catch (e) {
        print('Error removing item from cart: $e');
      }
    } else {
      print('Username not found in shared preferences');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs
        .getString('username'); // Retrieve username from shared preferences

    if (username != null) {
      try {
        // Replace with your API URL
        final response = await http.get(
          Uri.parse('$url/cart/$username'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> cartItems = jsonDecode(response.body)['items'];
          calculateTotalPrice(); // Recalculate total price after fetching

          return cartItems.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Failed to fetch cart: ${response.body}');
        }
      } catch (e) {
        throw Exception('Error fetching cart: $e');
      }
    } else {
      throw Exception('Username not found in shared preferences');
    }
  }

  void calculateTotalPrice() async {
    final items = await cartItems; // Wait for the cart items
    if (items != null) {
      double newTotalPrice = 0.0;
      for (var item in items) {
        final price = item['price'] ?? 0; // Default price 0
        final quantity = item['quantity'] ?? 0; // Default quantity 0
        newTotalPrice += price * quantity;
      }
      setState(() {
        totalPrice = newTotalPrice; // Update the total price in state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 8,
            buttonSize: 40,
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primary,
              size: 24,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'My Cart',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'Below are the items in your cart.',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: cartItems,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('Your cart is empty.'));
                                } else {
                                  items = snapshot.data!;

                                  double totalPrice = 0.0;

                                  // Calculate the total price
                                  for (var item in items) {
                                    final price =
                                        item['price'] ?? 0; // Default price 0
                                    final quantity = item['quantity'] ??
                                        0; // Default quantity 0
                                    totalPrice += price * quantity;
                                  }
                                  print(totalPrice);
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          final item = items[index];
                                          print(
                                              'itemmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm: $item');
                                          // Provide default values if any data is null
                                          final itemName = item['name'] ??
                                              'Unnamed Item'; // Default value
                                          final itemPrice = (item['price'] ?? 0)
                                              .toString(); // Convert to String

                                          final itemPhoto = item['photo'] ??
                                              ''; // Default empty string
                                          // final itemId = item['_id'] ??
                                          //     ''; // Default empty string
                                          final itemQuantity =
                                              item['quantity'] ??
                                                  0; // Default value (0)

                                          return CartItemWidget(
                                            itemName: itemName,
                                            itemPrice: itemPrice,
                                            itemPhoto: itemPhoto,
                                            quantity: itemQuantity,
                                            //itemId: itemId,
                                            fetchCartDetails:
                                                fetchCartDetails, // Pass the callback
                                            removeItemFromCart:
                                                removeItemFromCart, // Pass the function
                                          );
                                        },
                                      )
                                    ],
                                  );
                                }
                              }),
//                       ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 10, 24, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Total',
                                  style: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
                                  style: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x320E151B),
                              offset: Offset(
                                0.0,
                                -2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                          child: Text(
                            'Checkout ',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
