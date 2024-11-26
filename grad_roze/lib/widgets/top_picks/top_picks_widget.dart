import 'package:flutter/material.dart';
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
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                        child: Text(
                          'Our Top Picks',
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context)
                              .secondaryBackground, // Custom button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // More rounded radius
                            side: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1), // Added border
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TopPageWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'View More',
                          style: FlutterFlowTheme.of(context).bodyLarge,
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
