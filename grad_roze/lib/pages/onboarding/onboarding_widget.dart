import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'onboarding_model.dart';
export 'onboarding_model.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with TickerProviderStateMixin {
  late OnboardingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 6000.0.ms,
            begin: const Offset(0.0, -80.0),
            end: const Offset(0.0, 0.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 6000.0.ms,
            duration: 6000.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.0, -80.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.9, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.9, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.9, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                child: Container(
                  width: double.infinity,
                  height: 415,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 600,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: MasonryGridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemCount: 11,
                            itemBuilder: (context, index) {
                              return [
                                () => ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(16),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.asset(
                                        'assets/images/onboarding/WhatsApp_Image_2024-10-10_at_14.25.11_780be297.jpg',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/onboarding/download_(5).jpeg',
                                        width: 120,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(16),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.asset(
                                        'assets/images/onboarding/WhatsApp_Image_2024-10-10_at_14.25.11_79e2682e.jpg',
                                        width: 100,
                                        height: 0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(0),
                                      ),
                                      child: Image.asset(
                                        'assets/images/onboarding/download.jpg',
                                        width: 80,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/onboarding/download_(8).jpeg',
                                        width: 120,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/onboarding/ROSERIE_(1).jpg',
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(0),
                                      ),
                                      child: Image.asset(
                                        'assets/images/onboarding/download_(4).jpeg',
                                        width: 120,
                                        height: 190,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/onboarding/download_(2).jpeg',
                                        width: 120,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/onboarding/shphoto.jpg',
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(0),
                                      ),
                                      child: Image.asset(
                                        'assets/images/onboarding/deep_blue_tulips_.jpg',
                                        width: 120,
                                        height: 190,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                () => ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/images/onboarding/tulipmothers.jpeg',
                                        width: 120,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              ][index]();
                            },
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation']!),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 9, 0, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 240,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 20),
                            child: PageView(
                              controller: _model.pageViewController ??=
                                  PageController(initialPage: 0),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      48, 0, 48, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/2.png',
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.contain,
                                            ),
                                          ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation1']!),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/1.png',
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.contain,
                                            ),
                                          ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation2']!),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/3.png',
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.contain,
                                            ),
                                          ).animateOnPageLoad(animationsMap[
                                              'imageOnPageLoadAnimation3']!),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      48, 0, 48, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ' Personalized Gifting, Reimagined.',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: false,
                                            ),
                                      ).animateOnPageLoad(animationsMap[
                                          'textOnPageLoadAnimation1']!),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 16, 0, 0),
                                        child: Text(
                                          'Create unique and memorable gifts tailored to your recipient\'s preferences!',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: false,
                                              ),
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation2']!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      48, 0, 48, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Easy, Effortless, Exceptional',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              letterSpacing: 0.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: false,
                                            ),
                                      ).animateOnPageLoad(animationsMap[
                                          'textOnPageLoadAnimation3']!),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 16, 0, 0),
                                        child: Text(
                                          'user-friendly platform simplifies the gifting process!',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: false,
                                              ),
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation4']!),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       48, 0, 48, 0),
                                //   child: Column(
                                //     mainAxisSize: MainAxisSize.max,
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Text(
                                //         'Connect Across Distances',
                                //         textAlign: TextAlign.center,
                                //         style: FlutterFlowTheme.of(context)
                                //             .displayLarge
                                //             .override(
                                //               fontFamily: 'Funnel Display',
                                //               color:
                                //                   FlutterFlowTheme.of(context)
                                //                       .primary,
                                //               letterSpacing: 0.0,
                                //               fontWeight: FontWeight.bold,
                                //               useGoogleFonts: false,
                                //             ),
                                //       ).animateOnPageLoad(animationsMap[
                                //           'textOnPageLoadAnimation5']!),
                                //       Padding(
                                //         padding: const EdgeInsetsDirectional
                                //             .fromSTEB(0, 16, 0, 0),
                                //         child: Text(
                                //           'Send thoughtful presents to loved ones, no matter where they are!',
                                //           textAlign: TextAlign.center,
                                //           style: FlutterFlowTheme.of(context)
                                //               .labelLarge
                                //               .override(
                                //                 fontFamily: 'Funnel Display',
                                //                 fontSize: 14,
                                //                 letterSpacing: 0.0,
                                //                 fontWeight: FontWeight.normal,
                                //                 useGoogleFonts: false,
                                //               ),
                                //         ).animateOnPageLoad(animationsMap[
                                //             'textOnPageLoadAnimation6']!),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: smooth_page_indicator.SmoothPageIndicator(
                                controller: _model.pageViewController ??=
                                    PageController(initialPage: 0),
                                count: 3,
                                axisDirection: Axis.horizontal,
                                onDotClicked: (i) async {
                                  await _model.pageViewController!
                                      .animateToPage(
                                    i,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                  safeSetState(() {});
                                },
                                effect:
                                    smooth_page_indicator.ExpandingDotsEffect(
                                  expansionFactor: 3,
                                  spacing: 8,
                                  radius: 16,
                                  dotWidth: 8,
                                  dotHeight: 8,
                                  dotColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  activeDotColor:
                                      FlutterFlowTheme.of(context).primary,
                                  paintStyle: PaintingStyle.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        // Get the current page index
                        int currentIndex =
                            _model.pageViewController?.page?.toInt() ?? 0;

                        // Define the total number of slides
                        int totalSlides =
                            3; // Adjust this based on your PageView

                        if (currentIndex == totalSlides - 1) {
                          // Navigate to the new page when the last slide is reached
                          context.pushNamed(
                              'SignInUp'); // Replace 'newPage' with your desired route
                        } else {
                          // Go to the next page
                          await _model.pageViewController?.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      text: 'Next',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 60,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                        elevation: 4,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        hoverColor: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 44),
                    child: FFButtonWidget(
                      onPressed: () async {
                        context.pushNamed('SignInUp');
                      },
                      text: 'Skip',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 60,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                        elevation: 0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        hoverColor: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
