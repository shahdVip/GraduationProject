import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/custom/animations.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/config.dart' show url;

class UserSummaryWidget extends StatefulWidget {
  const UserSummaryWidget({super.key});

  @override
  _UserSummaryWidgetState createState() => _UserSummaryWidgetState();
}

class _UserSummaryWidgetState extends State<UserSummaryWidget> {
  int totalUsers = 0;
  int customers = 0;
  int businesses = 0;
  int admins = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserSummary();
  }

  Future<void> fetchUserSummary() async {
    try {
      final response = await http.get(Uri.parse('$url/summaryUserCounts'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalUsers = data['totalUsers'];
          customers = data['customerCount'];
          businesses = data['businessCount'];
          admins = data['adminCount'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user summary');
      }
    } catch (e) {
      print('Error fetching user summary: $e');
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Users',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Funnel Display',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                        const SizedBox(height: 8.0),
                        _buildSummaryRow(
                            context, "Total users", totalUsers.toString()),
                        _buildSummaryRow(
                            context, "Customers", customers.toString()),
                        _buildSummaryRow(
                            context, "Businesses", businesses.toString()),
                        _buildSummaryRow(context, "Admins", admins.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Pie chart
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: FlutterFlowTheme.of(context).primary,
                            value: customers.toDouble(),
                            title:
                                '${((customers / totalUsers) * 100).toStringAsFixed(1)}%',
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            color: FlutterFlowTheme.of(context).secondary,
                            value: businesses.toDouble(),
                            title:
                                '${((businesses / totalUsers) * 100).toStringAsFixed(1)}%',
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            color: FlutterFlowTheme.of(context).alternate,
                            value: admins.toDouble(),
                            title:
                                '${((admins / totalUsers) * 100).toStringAsFixed(1)}%',
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper method to build summary rows
  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          Text(
            value,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
        ],
      ),
    );
  }
}
