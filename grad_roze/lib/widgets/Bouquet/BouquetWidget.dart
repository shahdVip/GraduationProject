import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/toggle_icon.dart';

import 'package:flutter/material.dart';

class BouquetWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String orderDate;
  final bool isAdded;
  final VoidCallback onToggle; // Callback for toggle icon

  const BouquetWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.orderDate,
    required this.isAdded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color(0x520E151B),
              offset: Offset(0.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),

              // Title and Price Row
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Funnel Display',
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                    Text(
                      '\$$price',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Funnel Display',
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                    ),
                    ToggleIcon(
                      onPressed: onToggle, // Trigger callback
                      onIcon: Icon(
                        Icons.add_circle_outline,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24,
                      ),
                      offIcon: Icon(
                        Icons.add_sharp,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24,
                      ),
                      value: isAdded, // Dynamic state for toggle
                    ),
                  ],
                ),
              ),

              // Order Date
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Text(
                  'Ordered on $orderDate',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
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
    );
  }
}
