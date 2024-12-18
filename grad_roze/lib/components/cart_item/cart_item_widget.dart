import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grad_roze/config.dart';
import '../../custom/icon_button.dart';
import '../../pages/cart/MyCartModel.dart';
import '/custom/theme.dart';
import '/custom/widgets.dart';
import 'cart_item_model.dart';
export 'cart_item_model.dart';
import 'package:http/http.dart' as http;

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final MyCartModel model;
  final int index;
  final String username;
  final VoidCallback? onDelete;

  const CartItemWidget(
      {Key? key,
      required this.cartItem,
      required this.index,
      required this.username,
      required this.onDelete,
      required this.model})
      : super(key: key);

  Future<void> removeItemFromCart(String username, int index) async {
    final apiUrl = '$url/cart/$username/remove/item/$index';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Item removed successfully');
        // Optionally, call a callback or notify parent to refresh the list
      } else {
        print('Failed to remove item: ${response.body}');
      }
    } catch (error) {
      print('Error removing item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x320E151B),
              offset: Offset(0.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: 'ControllerImage-${cartItem.id}', // Unique tag
                transitionOnUserGestures: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    cartItem.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Text(
                          cartItem.name,
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'Funnel Display',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ),
                      Text(
                        '\$${cartItem.price.toInt()}',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: Text(
                          cartItem.businessName,
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    fontFamily: 'Funnel Display',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 40,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: FlutterFlowTheme.of(context).error,
                  size: 20,
                ),
                onPressed: () async {
                  // Call the remove API and refresh items
                  await removeItemFromCart(username, index);
                  await model.fetchCartItems(username);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
