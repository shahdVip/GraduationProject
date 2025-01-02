import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'BouquetCardModel.dart';
export 'BouquetCardModel.dart';

class BouquetCardWidget extends StatelessWidget {
  final Bouquet bouquet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BouquetCardWidget({
    super.key,
    required this.bouquet,
    this.onEdit,
    this.onDelete,
  });

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
                    bouquet.imageUrl,
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
                      bouquet.name,
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
                        Expanded(
                          child: RatingBar.builder(
                            onRatingUpdate: (_) {},
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            direction: Axis.horizontal,
                            initialRating: bouquet.rating,
                            unratedColor: FlutterFlowTheme.of(context).accent1,
                            itemCount: 5,
                            itemSize: 20,
                            glowColor: FlutterFlowTheme.of(context).primary,
                            ignoreGestures: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${bouquet.price}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Funnel Display',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                          overflow: TextOverflow.ellipsis,
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
                    onPressed: onEdit,
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8,
                    buttonSize: 40,
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: FlutterFlowTheme.of(context).alternate,
                      size: 24,
                    ),
                    onPressed: onDelete,
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
