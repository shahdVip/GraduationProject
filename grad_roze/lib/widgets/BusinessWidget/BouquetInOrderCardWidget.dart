import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/icon_button.dart';
import 'package:grad_roze/custom/nav/nav.dart';
import 'package:grad_roze/pages/business_pages/myOrders/BouquetInOrderView.dart';
import '/custom/theme.dart';
import '/custom/widgets.dart';
import '/config.dart' show url;
import 'package:http/http.dart' as http;

import 'BouquetInOrderCardModel.dart';

class BouquetInOrderCardWidget extends StatelessWidget {
  final BouquetInOrderCardModel bouquet;
  final VoidCallback? onArrowPressed;

  const BouquetInOrderCardWidget({
    Key? key,
    required this.bouquet,
    this.onArrowPressed,
  }) : super(key: key);

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
            offset: const Offset(0, 1),
          ),
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
                    '$url${bouquet.imageUrl}',
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
                      bouquet.bouquetName,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Funnel Display',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBarIndicator(
                          rating: bouquet.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          direction: Axis.horizontal,
                          unratedColor: FlutterFlowTheme.of(context).accent1,
                          itemCount: 5,
                          itemSize: 24,
                        ),
                        Text(
                          '\$${bouquet.price.toInt().toString()}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Funnel Display',
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ],
                    ),
                  ],
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
                      Icons.arrow_forward_sharp,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24,
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BouquetInOrderViewWidget(
                            bouquetId: bouquet.bouquetId,
                          ),
                        ),
                      );
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
