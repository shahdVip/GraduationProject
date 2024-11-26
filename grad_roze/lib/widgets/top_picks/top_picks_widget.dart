import 'package:flutter/material.dart';
import 'package:grad_roze/components/admin_order_card/admin_order_card_model.dart';
import 'package:grad_roze/custom/nav/nav.dart';
import 'package:grad_roze/custom/widgets.dart';
import 'package:grad_roze/index.dart';
import 'package:provider/provider.dart';

import '../../custom/theme.dart';
import '../../pages/homePage/topPage.dart';
import 'top_picks_model.dart';
import '../Bouquet/BouquetViewWidget.dart';

class TopPicksWidget extends StatelessWidget {
  const TopPicksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopPicksModel()..fetchTopPicks(),
      child: Consumer<TopPicksModel>(
        builder: (context, model, _) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (model.errorMessage != null) {
            return Center(
              child: Text(
                model.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (model.topPicks.isEmpty) {
            return const Center(
              child: Text('No top picks available'),
            );
          } else {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Container(
                width: double.infinity,
                height: 350, // Reduced the height of the container
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Generated code for this Text Widget...
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                        child: Text(
                          'Our Top Picks',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Funnel Display',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: model.topPicks.length,
                          itemBuilder: (context, index) {
                            return BouquetViewWidget(
                                model: model.topPicks[index]);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                      child: FFButtonWidget(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TopPageWidget(),
                            ),
                          );
                        },
                        text: 'View More',
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          iconAlignment: IconAlignment.end,
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: Color(0x00040425), // Button background color
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleSmallFamily,
                                color: FlutterFlowTheme.of(context).secondary,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: false,
                              ),
                          elevation: 0, // No shadow
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
