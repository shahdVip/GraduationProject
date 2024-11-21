import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';

import '../../widgets/MomentsModel.dart';
export '../../widgets/MomentsModel.dart';

class MomentPageWidget extends StatelessWidget {
  final MomentsModel moment;

  const MomentPageWidget({super.key, required this.moment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          moment.text, // Use the moment's name here
          style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Funnel Display',
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color:
              FlutterFlowTheme.of(context).primary, // Set the back icon color
        ),
      ),
    );
  }
}
