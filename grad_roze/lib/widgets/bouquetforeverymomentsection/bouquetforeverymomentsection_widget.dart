import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/widgets.dart';
import 'package:grad_roze/pages/homePage/momentPage.dart';
import '/widgets/MomentsModel.dart';
import 'package:grad_roze/services/moment_service.dart';
import 'package:grad_roze/widgets/moments_widget.dart';

class BouquetforeverymomentsectionWidget extends StatefulWidget {
  const BouquetforeverymomentsectionWidget({super.key});

  @override
  State<BouquetforeverymomentsectionWidget> createState() =>
      _BouquetforeverymomentsectionWidgetState();
}

class _BouquetforeverymomentsectionWidgetState
    extends State<BouquetforeverymomentsectionWidget> {
  late Future<List<MomentsModel>> _momentsFuture;

  /// Your function for handling taps (Preserved)
  void handleMomentTap(MomentsModel moment) {
    print("Tapped on moment: ${moment.text}");
    // Add any additional logic you need here
  }

  @override
  void initState() {
    super.initState();
    _momentsFuture = MomentService.fetchMoments(); // Fetch data dynamically
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Title Row
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Text(
                      'Bouquet for every moment',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'FunnelDisplay',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                          color: const Color(0xff770404)),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      print('View More button pressed');
                      // Add pagination or navigation logic here if needed
                    },
                    text: 'view more',
                    options: FFButtonOptions(
                      height: 40,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color.fromARGB(0, 4, 4, 37),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'FunnelDisplay',
                                color: const Color(0xFF040425),
                                fontSize: 10,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dynamic List of Moments
          Expanded(
            child: FutureBuilder<List<MomentsModel>>(
              future: _momentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('FutureBuilder Error: ${snapshot.error}');
                  print('StackTrace: ${snapshot.stackTrace}');
                  return const Center(child: Text("Error loading moments"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No moments available"));
                }

                final moments = snapshot.data!;
                return ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: moments.map((moment) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MomentPageWidget(moment: moment),
                          ),
                        );
                      },
                      child: MomentsWidget(
                        imageUrl: moment.imageUrl,
                        text: moment.text,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
