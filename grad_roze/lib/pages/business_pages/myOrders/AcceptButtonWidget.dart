import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grad_roze/custom/icon_button.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';
import 'package:http/http.dart' as http;

import '/config.dart' show url;
import '/custom/theme.dart';
import '/custom/widgets.dart';

class AcceptButtonWidget extends StatefulWidget {
  final OrderCardModel order; // Order ID
  final String business; // Business username

  const AcceptButtonWidget({
    super.key,
    required this.order,
    required this.business,
  });

  @override
  State<AcceptButtonWidget> createState() => _AcceptButtonWidgetState();
}

class _AcceptButtonWidgetState extends State<AcceptButtonWidget> {
  late String currentStatus; // Local status variable
  bool isButtonDisabled = false; // Tracks button state

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.status; // Initialize with the initial status

    // Fetch the current status from the API
    fetchOrderStatus().then((status) {
      if (mounted) {
        setState(() {
          currentStatus = status;
        });
      }
    }).catchError((error) {
      print('Failed to fetch initial status: $error');
    });
  }

  Future<String> fetchOrderStatus() async {
    final String urlAPI =
        '$url/orders/${widget.order.orderId}/business/${widget.business}/status';

    try {
      final response = await http.get(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['status']; // Return the status from the response
      } else {
        print('Failed to fetch status: ${response.body}');
        throw Exception('Failed to fetch order status');
      }
    } catch (e) {
      print('Error fetching status: $e');
      throw Exception('Error fetching order status');
    }
  }

  Future<void> updateOrderStatus() async {
    final String urlAPI =
        '$url/orders/${widget.order.orderId}/business/${widget.business}/updateStatus';

    try {
      setState(() => isButtonDisabled = true); // Temporarily disable button

      final response = await http.put(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        // Fetch the updated status directly
        final String updatedStatus = await fetchOrderStatus();

        // Update the local status
        if (mounted) {
          setState(() {
            currentStatus = updatedStatus;
            isButtonDisabled = false; // Re-enable button
          });
        }

        // Debugging
        print("Updated status: $currentStatus");

        // Handle "done" status: Show rating dialog
        if (currentStatus == "done") {
          await showRatingDialog();
        }
      } else {
        print('Failed to update order status: ${response.body}');
      }
    } catch (e) {
      print('Error updating order status: $e');
    } finally {
      setState(() => isButtonDisabled = false); // Ensure button is re-enabled
    }
  }

  Future<void> denyOrder() async {
    final String urlAPI =
        '$url/orders/${widget.order.orderId}/business/${widget.business}/DenyOrder';

    try {
      setState(() => isButtonDisabled = true); // Temporarily disable button

      final response = await http.put(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            currentStatus = "denied"; // Update status to "denied"
            isButtonDisabled = false; // Re-enable button
          });
        }

        print("Order denied successfully.");
      } else {
        print('Failed to deny order: ${response.body}');
      }
    } catch (e) {
      print('Error denying order: $e');
    } finally {
      setState(() => isButtonDisabled = false); // Ensure button is re-enabled
    }
  }

  Future<void> showRatingDialog() async {
    double selectedRating = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Custom border radius
              ),
              title: Text(
                'Rate the Service',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineMedium?.copyWith(
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.5,
                    ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Please rate your experience',
                      style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Flexible(
                          child: IconButton(
                            icon: Icon(
                              index < selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedRating = index + 1;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await submitRating(selectedRating);
                  },
                  child: Text(
                    'Submit',
                    style: FlutterFlowTheme.of(context).bodyMedium?.copyWith(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> submitRating(double rating) async {
    final String apiUrl = '$url/orders/updateRatings';

    final Map<String, dynamic> payload = {
      'businessName': widget.business,
      'orderId': widget.order.orderId,
      'newRating': rating,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl), // Changed to http.put
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Rating submitted successfully.');
        print('Response: ${response.body}');
      } else {
        print('Failed to submit rating. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error submitting rating: $error');
    }
  }

  String getButtonText(String status) {
    switch (status) {
      case "pending":
        return "Waiting for the Business to Accept it";
      case "accepted":
        return "Working on it!";
      case "waiting":
        return "I got it!";
      case "done":
        return "Rate it";
      case "denied":
        return "Denied";
      default:
        return "Unknown";
    }
  }

  Color getButtonColor(String status) {
    if (status == "denied") {
      return const Color(0xFF8B0707); // Red for "denied"
    }
    if (status == "pending" || status == "accepted") {
      return Colors.grey; // Gray for unclickable statuses
    } else if (status == "done") {
      return FlutterFlowTheme.of(context).primary; // Primary color
    }
    return const Color(0xFF0A7111); // Default green
  }

  Color getDenyButtonColor(String status) {
    return status == "denied" ? Colors.grey : const Color(0xFF8B0707);
  }

  bool isAcceptButtonEnabled(String status) {
    return !(status == "pending" || status == "accepted" || status == "denied");
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = getButtonText(currentStatus);
    final isAcceptClickable = isAcceptButtonEnabled(currentStatus);

    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0x00FFFFFF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Accept Button
          FFButtonWidget(
            onPressed: isAcceptClickable && !isButtonDisabled
                ? () async {
                    if (currentStatus == "done") {
                      await showRatingDialog(); // Open rating popup
                    } else {
                      await updateOrderStatus(); // Update status
                    }
                  }
                : null, // Disable button
            text: buttonText,
            options: FFButtonOptions(
              width: 300,
              height: 40,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: getButtonColor(currentStatus), // Dynamic color
              textStyle: FlutterFlowTheme.of(context).titleSmall?.copyWith(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Deny Button
          FlutterFlowIconButton(
            borderRadius: 8,
            buttonSize: 40,
            fillColor: getDenyButtonColor(currentStatus),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
            onPressed: currentStatus == "denied" || isButtonDisabled
                ? null
                : () async {
                    await denyOrder();
                  },
          ),
        ],
      ),
    );
  }
}
