import 'dart:convert';

import 'package:grad_roze/config.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'forgot_password_model.dart';
export 'forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  ForgotPasswordWidget({
    super.key,
    bool? emailfield,
  }) : emailfield = emailfield ?? true;

  bool emailfield;

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForgotPasswordModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.newPasswordTextController ??= TextEditingController();
    _model.newPasswordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

// Function to reset the password using OTP
  Future<void> resetPassword() async {
    final email = _model.emailAddressTextController.text.trim();
    final otp = _model.pinCodeController.text.trim();
    final newPassword = _model.newPasswordTextController.text.trim();

    if (email.isEmpty || otp.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(resetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully')),
        );
        context.pushNamed('SignInUp');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reset password')),
        );
        setState(() {
          widget.emailfield = true; // Toggle the boolean parameter
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

// Function to send the OTP
  Future<void> sendOtp() async {
    final email = _model.emailAddressTextController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(sendResetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your email')),
        );
        setState(() {
          widget.emailfield = false; // Toggle the boolean parameter
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30,
            ),
            onPressed: () async {
              context.pushNamed('SignInUp');
            },
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 670,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 32, 0, 8),
                              child: Text(
                                'Forgot Password',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displayMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 12, 12),
                              child: Text(
                                'A reset link will be sent to your email',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                            Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (widget.emailfield)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 12, 16, 0),
                                      child: TextFormField(
                                        controller:
                                            _model.emailAddressTextController,
                                        focusNode: _model.emailAddressFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.emailAddressTextController',
                                          const Duration(milliseconds: 2000),
                                          () => safeSetState(() {}),
                                        ),
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Email Address',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                    fontFamily:
                                                        'Funnel Display',
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                          errorStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                                lineHeight: 1.5,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 16, 16, 8),
                                          suffixIcon: _model
                                                  .emailAddressTextController!
                                                  .text
                                                  .isNotEmpty
                                              ? InkWell(
                                                  onTap: () async {
                                                    _model
                                                        .emailAddressTextController
                                                        ?.clear();
                                                    safeSetState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 20,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                              lineHeight: 1.5,
                                            ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .emailAddressTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  if (!widget.emailfield)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 15, 0, 0),
                                      child: PinCodeTextField(
                                        autoDisposeControllers: false,
                                        appContext: context,
                                        length: 6,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        enableActiveFill: false,
                                        autoFocus: false,
                                        enablePinAutofill: true,
                                        errorTextSpace: 16,
                                        showCursor: true,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
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
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          inactiveColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          selectedColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                        controller: _model.pinCodeController,
                                        onChanged: (_) {},
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: _model
                                            .pinCodeControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  // Generated code for this newPassword Widget...
                                  if (!widget.emailfield)
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 12, 16, 0),
                                      child: TextFormField(
                                        controller:
                                            _model.newPasswordTextController,
                                        focusNode: _model.newPasswordFocusNode,
                                        autofocus: false,
                                        obscureText:
                                            !_model.newPasswordVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'New Password',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                    fontFamily:
                                                        'Funnel Display',
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
                                                  ),
                                          errorStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                                lineHeight: 1.5,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 16, 16, 8),
                                          suffixIcon: InkWell(
                                            onTap: () => safeSetState(
                                              () => _model
                                                      .newPasswordVisibility =
                                                  !_model.newPasswordVisibility,
                                            ),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              _model.newPasswordVisibility
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                              lineHeight: 1.5,
                                            ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .newPasswordTextControllerValidator
                                            .asValidator(context),
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
                  Stack(
                    children: [
                      if (widget.emailfield)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 12, 16, 24),
                          child: FFButtonWidget(
                            onPressed: sendOtp,
                            text: 'Send Link',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 60,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
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
                            ),
                          ),
                        ),
                      if (!widget.emailfield)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 12, 16, 24),
                          child: FFButtonWidget(
                            onPressed: resetPassword,
                            text: 'Reset Password',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 60,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
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
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
