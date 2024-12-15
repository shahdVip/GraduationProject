// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:grad_roze/custom/icon_button.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '/config.dart' show url;
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'acceptOrDenyModel.dart';

export 'acceptOrDenyModel.dart';

class AcceptOrDenyWidget extends StatefulWidget {
  final OrderCardModel order; // Order ID
  final String business; // Business username

  AcceptOrDenyWidget({
    super.key,
    required this.order,
    required this.business,
  });

  @override
  State<AcceptOrDenyWidget> createState() => _AcceptOrDenyWidgetState();
}

class _AcceptOrDenyWidgetState extends State<AcceptOrDenyWidget> {
  bool isAcceptButtonDisabled = false;
  bool isDenyButtonClicked = false;

  String getButtonText(String status) {
    switch (status) {
      case "pending":
        return "Accept";
      case "accepted":
        return "Ready";
      case "waiting":
        return "Waiting for the Customer";
      case "done":
        return "Done!";
      default:
        return "Accept";
    }
  }

  Color getAcceptButtonColor(String text) {
    if (widget.order.status == "denied" || isAcceptButtonDisabled) {
      return Colors.grey; // Gray when the button is disabled
    }
    if (text == "Done" || text == "Waiting for the Customer") {
      return FlutterFlowTheme.of(context).primary; // Primary color
    }
    return const Color(0xFF0A7111); // Default green
  }

  Color getDenyButtonColor(String status) {
    if (status == "denied") {
      return FlutterFlowTheme.of(context).primary;
    }
    return (status != "pending" && status != "denied")
        ? Colors.grey // Gray for other statuses
        : const Color(0xFF8B0707); // Red for "pending"
  }

  bool isDenyButtonDisabled(String status) {
    return status == "denied" || (status != "pending" && status != "denied");
  }

  Future<void> updateOrderStatus() async {
    final String urlAPI =
        '$url/orders/${widget.order.orderId}/business/${widget.business}/updateStatus';

    try {
      final response = await http.put(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final Map<String, dynamic> updatedOrder = json.decode(response.body);
        print('Order updated successfully: $updatedOrder');

        // Extract the correct status for the business
        final List<dynamic> businessUsernames =
            updatedOrder['businessUsername'];
        final List<dynamic> statuses = updatedOrder['status'];

        // Find the index of the current businessUsername
        final int businessIndex = businessUsernames.indexOf(widget.business);

        if (businessIndex == -1) {
          throw Exception('Business username not found in the updated order');
        }

        // Update the widget's status with the corresponding status
        setState(() {
          widget.order.status = statuses[businessIndex];
          isAcceptButtonDisabled = false; // Re-enable button
        });
      } else {
        print('Failed to update order status: ${response.body}');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> denyOrder() async {
    final String urlAPI =
        '$url/orders/${widget.order.orderId}/business/${widget.business}/DenyOrder';

    try {
      final response = await http.put(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Order denied successfully: $responseData');

        // Access the 'order' object
        final Map<String, dynamic>? updatedOrder = responseData['order'];

        if (updatedOrder == null) {
          throw Exception('Invalid response: order object is null');
        }

        // Extract 'businessUsername' and 'status' lists
        final List<dynamic>? businessUsernames =
            updatedOrder['businessUsername'] as List<dynamic>?;
        final List<dynamic>? statuses =
            updatedOrder['status'] as List<dynamic>?;

        if (businessUsernames == null || statuses == null) {
          throw Exception(
              'Invalid response: businessUsername or status is missing');
        }

        // Find the index of the current businessUsername
        final int businessIndex = businessUsernames.indexOf(widget.business);

        if (businessIndex == -1) {
          throw Exception('Business username not found in the updated order');
        }

        // Update the widget's status with "denied"
        setState(() {
          widget.order.status = statuses[businessIndex];
          isAcceptButtonDisabled = true;
          isDenyButtonClicked = true;
        });
      } else {
        print('Failed to deny order: ${response.body}');
      }
    } catch (e) {
      print('Error denying order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = getButtonText(widget.order.status);
    final isDone = buttonText == "Done";
    final isWaitingForTheCustomer = buttonText == "Waiting for the Customer";
    final denyButtonDisabled = isDenyButtonDisabled(widget.order.status);

    // Update the logic for disabling the Accept Button
    final isAcceptButtonDisabled =
        widget.order.status == "denied" || this.isAcceptButtonDisabled;

    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0x00FFFFFF),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FFButtonWidget(
            onPressed:
                isDone || isAcceptButtonDisabled || isWaitingForTheCustomer
                    ? null
                    : () async {
                        setState(() {
                          this.isAcceptButtonDisabled = true;
                        });
                        print('$buttonText Button pressed ...');

                        // Call the API to update the status
                        await updateOrderStatus();
                      },
            text: buttonText,
            options: FFButtonOptions(
              width: 300,
              height: 40,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: getAcceptButtonColor(buttonText),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    color: Colors.white,
                    letterSpacing: 0.0,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).titleSmallFamily),
                  ),
              elevation: 0,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          FlutterFlowIconButton(
            borderRadius: 8,
            buttonSize: 40,
            fillColor: getDenyButtonColor(widget.order.status),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
            onPressed: denyButtonDisabled
                ? null
                : () {
                    setState(() {
                      isDenyButtonClicked = true;
                      this.isAcceptButtonDisabled =
                          true; // Optionally disable Accept
                      denyOrder();
                    });
                    print('Deny Button pressed ...');
                  },
          ),
        ],
      ),
    );
  }
}
