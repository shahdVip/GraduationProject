import 'package:image_picker/image_picker.dart';

import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '/config.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:mime/mime.dart';

import 'edit_user_model.dart';
export 'edit_user_model.dart';

class EditUserWidget extends StatefulWidget {
  final String usernamee;
  final String profilePhoto;
  final String role;

  const EditUserWidget(
      {super.key,
      required this.usernamee,
      required this.role,
      required this.profilePhoto});

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget>
    with TickerProviderStateMixin {
  late EditUserModel _model;
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> deleteUser(String username, BuildContext context) async {
    try {
      // Define the API URL
      final url = Uri.parse(deleteUserUrll);

      // Send the DELETE request
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        // User deleted successfully
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User deleted successfully!'),
        ));
      } else {
        // Handle errors from the server
        final data = jsonDecode(response.body);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${data['message']}'),
        ));
      }
    } catch (error) {
      // Handle any other errors
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  // Future<void> updateUserButton(BuildContext context) async {
  //   // Extracting the data
  //   String email = _model.emailTextController.text;
  //   String phoneNumber = _model.phineNumberTextController.text;
  //   String address = _model.addressTextController.text;
  //   String password = _model.passwordTextController.text;
  //   // String profilePhoto = profilePhotoController.text;

  //   // Create a JSON object with the fields to update
  //   Map<String, dynamic> body = {
  //     'email': email.isNotEmpty ? email : null,
  //     'phoneNumber': phoneNumber.isNotEmpty ? phoneNumber : null,
  //     'address': address.isNotEmpty ? address : null,
  //     'password': password.isNotEmpty ? password : null,
  //     // 'profilePhoto': profilePhoto.isNotEmpty ? profilePhoto : null,
  //   };

  //   // Remove any null values
  //   body.removeWhere((key, value) => value == null);

  //   // Sending the PUT request
  //   try {
  //     final response = await http.put(
  //       Uri.parse('http://192.168.1.9:3000/updateUser/${widget.usernamee}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(body),
  //     );

  //     if (response.statusCode == 200) {
  //       // If the server returns a success response
  //       final data = jsonDecode(response.body);
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('User updated successfully!'),
  //       ));
  //     } else {
  //       // If the server returns an error
  //       final data = jsonDecode(response.body);
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Error: ${data['message']}'),
  //       ));
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Error: $error'),
  //     ));
  //   }
  // }

  Future<void> updateUserButton(BuildContext context) async {
    // Extracting text field data
    String email = _model.emailTextController.text;
    String phoneNumber = _model.phineNumberTextController.text;
    String address = _model.addressTextController.text;
    String password = _model.passwordTextController.text;

    // Create a `multipart/form-data` request
    final uri = Uri.parse('$url/updateUser/${widget.usernamee}');
    var request = http.MultipartRequest('PUT', uri);

    // Adding fields if not empty
    if (email.isNotEmpty) request.fields['email'] = email;
    if (phoneNumber.isNotEmpty) request.fields['phoneNumber'] = phoneNumber;
    if (address.isNotEmpty) request.fields['address'] = address;
    if (password.isNotEmpty) {
      request.fields['password'] = password;
    }

    // Adding the image as bytes, if available
    if (_image != null) {
      // Check and split MIME type
      final mimeTypeData = lookupMimeType('', headerBytes: _image!)?.split('/');
      request.files.add(
        http.MultipartFile.fromBytes(
          'profilePhoto',
          _image!,
          contentType: mimeTypeData != null
              ? MediaType(mimeTypeData[0], mimeTypeData[1])
              : MediaType('image', 'jpeg'), // Default to jpeg
          filename: 'profile_photo.jpg',
        ),
      );
    } else {
      // Show an error if the image is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected for upload')),
      );
      return; // Exit the function early
    }

    try {
      // Sending the request
      final response = await request.send();

      if (response.statusCode == 200) {
        // If the server returns a success response
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User updated successfully!'),
        ));
        Navigator.pop(context);
      } else {
        // If the server returns an error
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${data['message']}'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditUserModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.addressTextController ??= TextEditingController();
    _model.addressFocusNode ??= FocusNode();

    _model.phineNumberTextController ??= TextEditingController();
    _model.phineNumberFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent4,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 70, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        color: Color(0x1E000000),
                        offset: Offset(
                          0,
                          5,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 0),
                        child: Text(
                          'Edit User',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Funnel Display',
                                useGoogleFonts: false,
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: _image != null
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 100,
                                                  backgroundImage: MemoryImage(
                                                      _image!), // Use MemoryImage if _image is not null
                                                )
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 100,
                                                  backgroundImage: (widget
                                                          .profilePhoto.isEmpty)
                                                      ? const AssetImage(
                                                          'assets/images/defaults/default_avatar.png') // Default image
                                                      : NetworkImage(widget
                                                          .profilePhoto), // Profile photo from the URL
                                                ),
                                        ),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: selectImage,
                                      text: 'Change Photo',
                                      options: FFButtonOptions(
                                        height: 44,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(24, 0, 24, 0),
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                        hoverColor: FlutterFlowTheme.of(context)
                                            .alternate,
                                        hoverBorderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2,
                                        ),
                                        hoverTextColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        hoverElevation: 3,
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 16)),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                    child: TextFormField(
                                      controller: _model.emailTextController,
                                      focusNode: _model.emailFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.emailTextController',
                                        const Duration(milliseconds: 2000),
                                        () => safeSetState(() {}),
                                      ),
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        suffixIcon: _model.emailTextController!
                                                .text.isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model.emailTextController
                                                      ?.clear();
                                                  safeSetState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Color(0xFF757575),
                                                  size: 22,
                                                ),
                                              )
                                            : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            useGoogleFonts: false,
                                            letterSpacing: 0.0,
                                          ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: _model
                                          .emailTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                    child: TextFormField(
                                      controller: _model.addressTextController,
                                      focusNode: _model.addressFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.addressTextController',
                                        const Duration(milliseconds: 2000),
                                        () => safeSetState(() {}),
                                      ),
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Address',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.home_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        suffixIcon: _model
                                                .addressTextController!
                                                .text
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model.addressTextController
                                                      ?.clear();
                                                  safeSetState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Color(0xFF757575),
                                                  size: 22,
                                                ),
                                              )
                                            : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            useGoogleFonts: false,
                                            letterSpacing: 0.0,
                                          ),
                                      validator: _model
                                          .addressTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                    child: TextFormField(
                                      controller:
                                          _model.phineNumberTextController,
                                      focusNode: _model.phineNumberFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.phineNumberTextController',
                                        const Duration(milliseconds: 2000),
                                        () => safeSetState(() {}),
                                      ),
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.phone_android,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        suffixIcon: _model
                                                .phineNumberTextController!
                                                .text
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model
                                                      .phineNumberTextController
                                                      ?.clear();
                                                  safeSetState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Color(0xFF757575),
                                                  size: 22,
                                                ),
                                              )
                                            : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            useGoogleFonts: false,
                                            letterSpacing: 0.0,
                                          ),
                                      keyboardType: TextInputType.number,
                                      validator: _model
                                          .phineNumberTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                    child: TextFormField(
                                      controller: _model.passwordTextController,
                                      focusNode: _model.passwordFocusNode,
                                      autofocus: false,
                                      obscureText: !_model.passwordVisibility,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.password_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () => safeSetState(
                                            () => _model.passwordVisibility =
                                                !_model.passwordVisibility,
                                          ),
                                          focusNode:
                                              FocusNode(skipTraversal: true),
                                          child: Icon(
                                            _model.passwordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0xFF757575),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            useGoogleFonts: false,
                                            letterSpacing: 0.0,
                                          ),
                                      validator: _model
                                          .passwordTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 24),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 16, 0, 0),
                                            child: SelectionArea(
                                                child: Text(
                                              'This user role is: ',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        useGoogleFonts: false,
                                                        letterSpacing: 0.0,
                                                      ),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 4, 0, 0),
                                            child: SelectionArea(
                                                child: Text(
                                              widget.role,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        useGoogleFonts: false,
                                                        letterSpacing: 0.0,
                                                      ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24, 12, 24, 24),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0.05),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                text: 'Cancel',
                                options: FFButtonOptions(
                                  height: 44,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  hoverColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  hoverBorderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  hoverTextColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  hoverElevation: 3,
                                ),
                              ),
                            ),
                            Container(
                              height: 95,
                              decoration: const BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      await updateUserButton(context);
                                    },
                                    text: 'Save Changes',
                                    options: FFButtonOptions(
                                      height: 44,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24, 0, 24, 0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            useGoogleFonts: false,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      hoverElevation: 3,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 5, 0, 0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        await deleteUser(
                                            widget.usernamee, context);
                                      },
                                      text: 'Delete User',
                                      icon: const FaIcon(
                                        FontAwesomeIcons.trashAlt,
                                        size: 15,
                                      ),
                                      options: FFButtonOptions(
                                        height: 44,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(24, 0, 24, 0),
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                        elevation: 0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          width: 0,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                        hoverElevation: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation']!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
