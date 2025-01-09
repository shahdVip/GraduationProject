import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart' show url;
import '/custom/theme.dart';

class OrderSummaryWidget extends StatefulWidget {
  const OrderSummaryWidget({super.key});

  @override
  _OrderSummaryWidgetState createState() => _OrderSummaryWidgetState();
}

class _OrderSummaryWidgetState extends State<OrderSummaryWidget> {
  int totalOrders = 0;
  int doneOrders = 0;
  String mostWantedBouquet = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderSummary();
  }

  Future<void> fetchOrderSummary() async {
    try {
      final response = await http.get(Uri.parse('$url/orders/orderSummary'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalOrders = data['totalOrders'];
          doneOrders = data['doneOrders'];
          mostWantedBouquet = data['mostWantedBouquet']?['name'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load order summary');
      }
    } catch (e) {
      print('Error fetching order summary: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSummaryCard(
                          context,
                          title: 'Total Orders',
                          value: totalOrders.toString(),
                          icon: Icons.shopping_cart,
                          color: FlutterFlowTheme.of(context).secondary,
                        ),
                        _buildSummaryCard(
                          context,
                          title: 'Done Orders',
                          value: doneOrders.toString(),
                          icon: Icons.check_circle,
                          color: FlutterFlowTheme.of(context).secondary,
                        ),
                        _buildSummaryCard(
                          context,
                          title: 'Top Bouquet',
                          value: mostWantedBouquet,
                          icon: Icons.local_florist,
                          color: FlutterFlowTheme.of(context).secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: 100, // Adjusted width to prevent overflow
        height: 122, // Adjusted height for better visuals
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25.0,
              color: color,
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Funnel Display',
                    fontSize: 10.0,
                    color: color,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Funnel Display',
                    fontSize: 12.0,
                    color: FlutterFlowTheme.of(context).primary,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
