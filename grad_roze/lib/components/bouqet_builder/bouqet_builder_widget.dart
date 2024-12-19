import 'package:url_launcher/url_launcher.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/video_player.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'bouqet_builder_model.dart';
export 'bouqet_builder_model.dart';

class BouqetBuilderWidget extends StatefulWidget {
  const BouqetBuilderWidget({super.key});

  @override
  State<BouqetBuilderWidget> createState() => _BouqetBuilderWidgetState();
}

class _BouqetBuilderWidgetState extends State<BouqetBuilderWidget> {
  late BouqetBuilderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BouqetBuilderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  final Uri bouquetBuilderUri = Uri.parse("http://192.168.1.5:5173/");

  // Future<void> _launchURL() async {
  //   if (!await launchUrl(bouquetBuilderUri,
  //       mode: LaunchMode.externalApplication)) {
  //     throw 'Could not launch $bouquetBuilderUri';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional(0, 0),
      children: [
        Align(
          alignment: AlignmentDirectional(0, 0),
          child: FlutterFlowVideoPlayer(
            path: 'assets/videos/lv_0_20241207223710.mp4',
            videoType: VideoType.asset,
            autoPlay: true,
            looping: true,
            showControls: false,
            allowFullScreen: false,
            allowPlaybackSpeedMenu: false,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                'Build a Bouqet !',
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: 'Funnel Display',
                      color: FlutterFlowTheme.of(context).info,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            FFButtonWidget(
              onPressed: () async {
                context.pushNamed('webview');
              },
              text: 'Start',
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
              options: FFButtonOptions(
                height: 40,
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                iconAlignment: IconAlignment.end,
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: Color(0x00040425),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Funnel Display',
                      color: Color(0xFF040425),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: false,
                    ),
                elevation: 0,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
