import 'package:grad_roze/config.dart';
import '/components/usr_rgstr_dialog/usr_rgstr_dialog_widget.dart';

import '/custom/theme.dart';
import '/custom/timer.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'otp_model.dart';
export 'otp_model.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    String? email,
    String? role,
  })  : email = email ?? ' ',
        role = role ?? ' ';

  final String email;
  final String role;
  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  late OtpModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtpModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.timerController.onStartTimer();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> verifyOtpCustomer(
      BuildContext context, String email, String enteredOtp) async {
    var verifyBody = {
      "email": email,
      "otp": enteredOtp,
    };

    try {
      // Make the POST request to verify the OTP
      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(verifyBody),
      );

      // Parse the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['valid'] == true) {
          // OTP is valid and not expired

          // Show the dialog immediately instead of creating the user request
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: const AlignmentDirectional(0, 0)
                    .resolve(Directionality.of(context)),
                child: GestureDetector(
                  onTap: () => FocusScope.of(dialogContext).unfocus(),
                  child: const UsrRgstrDialogWidget(), // Your dialog widget
                ),
              );
            },
          );
        } else if (response.statusCode == 400) {
          // OTP is invalid or expired, delete the user record
          final deleteResponse = await http.post(
            Uri.parse(deleteUserUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          );

          if (deleteResponse.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Incorrect/Expired OTP. Sign up again.'),
                  backgroundColor: Colors.red),
            );
            context.pushNamed('onboarding');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to delete user record.'),
                  backgroundColor: Colors.red),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bad Request: ${response.body}')),
          );
        }
      }
    } catch (e) {
      // Exception handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> verifyOtpAndNavigate(
      BuildContext context, String email, String enteredOtp) async {
    var verifyBody = {
      "email": email,
      "otp": enteredOtp,
    };

    try {
      // Make the POST request to verify the OTP
      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(verifyBody),
      );

      // Parse the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['valid'] == true) {
          // OTP is valid and not expired

          // Now, create the user request
          var userRequestBody = {
            "email":
                email, // Email is required to fetch user data from the backend
          };

          final createRequestResponse = await http.post(
            Uri.parse(createUserRequestUrl), // URL to create the user request
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userRequestBody),
          );

          // Check if the request was successful
          if (createRequestResponse.statusCode == 200) {
            // Proceed to show the dialog instead of navigating to the homepage
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  alignment: const AlignmentDirectional(0, 0)
                      .resolve(Directionality.of(context)),
                  child: GestureDetector(
                    onTap: () => FocusScope.of(dialogContext).unfocus(),
                    child:
                        const UsrRgstrDialogWidget(), // Replace with your dialog widget
                  ),
                );
              },
            );
          } else {
            // Handle failed user request creation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create user request.')),
            );
          }
        }
      } else if (response.statusCode == 400) {
        // OTP is invalid or expired, delete the user record
        final deleteResponse = await http.post(
          Uri.parse(deleteUserUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        );

        if (deleteResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Incorrect/Expired OTP. Sign up again.'),
                backgroundColor: Colors.red),
          );
          context.pushNamed('onboarding');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to delete user record.'),
                backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bad Request: ${response.body}')),
        );
      }
    } catch (e) {
      // Exception handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              'assets/images/defaults/mail-attack_(1).png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 6, 0, 0),
                              child: Text(
                                'Verify your email',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 20,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 0, 0),
                              child: Text(
                                'OTP code is sent to',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 0, 0),
                              child: Text(
                                widget.email,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0x33FFFFFF),
                            border: Border.all(
                              color: const Color(0x99FFFFFF),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 48, 24, 48),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PinCodeTextField(
                                  autoDisposeControllers: false,
                                  appContext: context,
                                  length: 6,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 20,
                                        letterSpacing: 0.0,
                                      ),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  enableActiveFill: false,
                                  autoFocus: true,
                                  enablePinAutofill: true,
                                  errorTextSpace: 16,
                                  showCursor: true,
                                  cursorColor: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  obscureText: false,
                                  hintCharacter: '*',
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    fieldHeight: 44,
                                    fieldWidth: 44,
                                    borderWidth: 2,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    shape: PinCodeFieldShape.box,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    inactiveColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    selectedColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                  controller: _model.pinCodeController,
                                  onChanged: (_) {},
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _model.pinCodeControllerValidator
                                      .asValidator(context),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 16, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.clock,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 0, 0),
                                          child: FlutterFlowTimer(
                                            initialTime:
                                                _model.timerInitialTimeMs,
                                            getDisplayTime: (value) =>
                                                StopWatchTimer.getDisplayTime(
                                              value,
                                              hours: false,
                                              milliSecond: false,
                                            ),
                                            controller: _model.timerController,
                                            updateStateInterval: const Duration(
                                                milliseconds: 1000),
                                            onChanged: (value, displayTime,
                                                shouldUpdate) {
                                              _model.timerMilliseconds = value;
                                              _model.timerValue = displayTime;

                                              if (value == 0) {
                                                // Timer has ended, update the UI
                                                safeSetState(() {});
                                              } else if (shouldUpdate) {
                                                // Regular updates
                                                safeSetState(() {});
                                              }
                                            },
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Funnel Display',
                                                  useGoogleFonts: false,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  fontSize: 18,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_model.timerMilliseconds == 0)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                'Didn\'t recieve the code?',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                // Reset the timer
                                _model.timerController.onResetTimer();
                                _model.timerController.onStartTimer();

                                // User email (you should have it stored)
                                final String useremail = widget.email;

                                // Make the POST request
                                try {
                                  final response = await http.post(
                                    Uri.parse(resendCodeUrl),
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                    body: jsonEncode({'email': useremail}),
                                  );

                                  if (response.statusCode == 200) {
                                    // Success - Show a success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('OTP resent successfully')),
                                    );
                                  } else {
                                    // Error - Show an error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Failed to resend OTP'),
                                          backgroundColor: Colors.red),
                                    );
                                  }
                                } catch (e) {
                                  // Exception - Show an error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('An error occurred'),
                                        backgroundColor: Colors.red),
                                  );
                                }
                              },
                              text: 'Resend code',
                              options: FFButtonOptions(
                                width: 130,
                                height: 40,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                hoverColor:
                                    FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                  child: FFButtonWidget(
                    onPressed: () async {
                      // Get the OTP entered by the user from the PinCodeTextField controller
                      String enteredOtp = _model.pinCodeController.text;
                      if (widget.role == 'Business')
                        verifyOtpAndNavigate(context, widget.email, enteredOtp);
                      else if (widget.role == 'Customer')
                        verifyOtpCustomer(context, widget.email, enteredOtp);
                    },
                    text: 'Continue',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Funnel Display',
                                useGoogleFonts: false,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                letterSpacing: 0.0,
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
              ].divide(const SizedBox(height: 130)),
            ),
          ),
        ),
      ),
    );
  }
}
