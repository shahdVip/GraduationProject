import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/custom/theme.dart';
import '/config.dart' show url;

class TopBusinessesWidget extends StatefulWidget {
  const TopBusinessesWidget({Key? key}) : super(key: key);

  @override
  _TopBusinessesWidgetState createState() => _TopBusinessesWidgetState();
}

class _TopBusinessesWidgetState extends State<TopBusinessesWidget> {
  List<Map<String, dynamic>> topBusinesses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopBusinesses();
  }

  Future<void> fetchTopBusinesses() async {
    try {
      final response = await http.get(Uri.parse('$url/orders/topBusinesses'));
      if (response.statusCode == 200) {
        final data =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          topBusinesses = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load top businesses');
      }
    } catch (e) {
      print('Error fetching top businesses: $e');
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
                    'Top Businesses',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  topBusinesses.isEmpty
                      ? Text(
                          'No data available',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Funnel Display',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: topBusinesses.length,
                          itemBuilder: (context, index) {
                            final business = topBusinesses[index];
                            return _buildBusinessCard(context, business, index);
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildBusinessCard(
      BuildContext context, Map<String, dynamic> business, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business['_id'],
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Funnel Display',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${business['orderCount']} orders',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
