import 'package:grad_roze/components/business_components/inventory_comp/update_in_inventory/update_in_inventory_widget.dart';
import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'flower_in_inventory_card_model.dart';
export 'flower_in_inventory_card_model.dart';

class FlowerInInventoryCardWidget extends StatefulWidget {
  final VoidCallback refreshFlowers; // Add this callback

  final Map<String, dynamic> flowerData;

  const FlowerInInventoryCardWidget({
    super.key,
    required this.flowerData,
    required this.refreshFlowers, // Add to constructor
  });

  @override
  State<FlowerInInventoryCardWidget> createState() =>
      _FlowerInInventoryCardWidgetState();
}

class _FlowerInInventoryCardWidgetState
    extends State<FlowerInInventoryCardWidget> {
  late FlowerInInventoryCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FlowerInInventoryCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 0,
            color: FlutterFlowTheme.of(context).alternate,
            offset: const Offset(
              0,
              1,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${widget.flowerData['image']}', // Display flower image
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flowerData['flowerType'], // Display flower type

                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Funnel Display',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: Text(
                            '${widget.flowerData['color']}', // Display flower color

                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Text(
                          'Qty: ${widget.flowerData['quantity']}', // Display flower quantity

                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Funnel Display',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ],
                    ),
                  ].divide(const SizedBox(height: 4)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 8,
                    buttonSize: 40,
                    icon: Icon(
                      Icons.edit_outlined,
                      color: FlutterFlowTheme.of(context).alternate,
                      size: 24,
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: const UpdateInInventoryWidget(),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8,
                    buttonSize: 40,
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: FlutterFlowTheme.of(context).alternate,
                      size: 24,
                    ),
                    onPressed: () async {
                      var confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: const Text('Delete flower'),
                                content: const Text(
                                    'Are you sure you want to delete this flower?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        alertDialogContext, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext, true),
                                    child: const Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;

                      if (confirmDialogResponse) {
                        final username = await SharedPreferences.getInstance()
                            .then((prefs) => prefs
                                .getString('username')); // Retrieve username
                        final flowerId = widget.flowerData[
                            '_id']; // Replace with the actual flower ID

                        if (username != null) {
                          try {
                            final response = await http.delete(
                              Uri.parse(
                                  '$url/inventory/$username/flowers/$flowerId'),
                              headers: {
                                'Content-Type': 'application/json',
                              },
                            );

                            if (response.statusCode == 200) {
                              // Handle success (e.g., refresh the list)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Flower deleted successfully')),
                              );
                              widget.refreshFlowers(); // Trigger the refresh
                            } else {
                              // Handle error
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to delete flower.')),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $error')),
                            );
                          }
                        }
                      }
                    },
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
