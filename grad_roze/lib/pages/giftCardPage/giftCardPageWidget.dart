import '../../config.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'GiftCardWidget.dart';
import 'giftCardPageModel.dart';

class GiftCardPageWidget extends StatefulWidget {
  final String username;
  const GiftCardPageWidget({super.key, required this.username});

  @override
  State<GiftCardPageWidget> createState() => _GiftCardPageWidgetState();
}

class _GiftCardPageWidgetState extends State<GiftCardPageWidget>
    with SingleTickerProviderStateMixin {
  late GiftCardPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String? _generatedMessage;
  bool _showGiftCard = false; // Control gift card visibility

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GiftCardPageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _generateGiftCard() async {
    final receiver = _model.textController1!.text.trim();
    final sender = _model.textController2!.text.trim();
    final inputText = _model.textController3!.text.trim();

    if (receiver.isEmpty || sender.isEmpty || inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _showGiftCard = false; // Hide gift card before generating a new one
    });

    try {
      final response = await http.post(
        Uri.parse(
            '$url/ai/generate-giftCardMessage'), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'inputText': inputText}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _generatedMessage = data['message'];
          _showGiftCard = true; // Show gift card with animation
        });
      } else {
        throw Exception('Failed to generate message');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: false,
              floating: false,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              elevation: 2,
              automaticallyImplyLeading: false,
              title: Text(
                "Gift Card Generator",
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: 'Funnel Display',
                      useGoogleFonts: false,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              centerTitle: true,
            )
          ],
          body: Builder(
            builder: (context) {
              return SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Heading Text
                      Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 20, 20, 5),
                          child: Text(
                            'Let\'s help you write a meaningful gift card',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Funnel Display',
                                  useGoogleFonts: false,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                      // Instruction Text
                      Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 20),
                          child: Text(
                            'Please enter a feeling, occasion, or a short message for the gift card (e.g., \'I love you,\' \'Congratulations,\' \'Happy Birthday\').',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  useGoogleFonts: false,
                                  fontSize: 10,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                      // Input Fields
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              _buildInputField(
                                label: 'Who is this for?',
                                controller: _model.textController1!,
                                hint: 'Example: Sarah',
                              ),
                              _buildInputField(
                                label: 'Who is this from?',
                                controller: _model.textController2!,
                                hint: 'Your Name',
                              ),
                              _buildInputField(
                                label: 'What would you like to say?',
                                controller: _model.textController3!,
                                hint:
                                    'Example: "I love you" or "Happy Birthday!"',
                                maxLines: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: _generateGiftCard,
                                    text: 'Generate',
                                    icon: const Icon(Icons.auto_awesome,
                                        size: 15),
                                    options: FFButtonOptions(
                                      height: 40,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            useGoogleFonts: false,
                                            color: Colors.white,
                                          ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 5, 0),
                                    child: FlutterFlowIconButton(
                                      borderColor:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: 8,
                                      buttonSize: 40,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      icon: Icon(
                                        Icons.clear_sharp,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _model.textController1!.clear();
                                          _model.textController2!.clear();
                                          _model.textController3!.clear();
                                          _generatedMessage = null;
                                          _showGiftCard =
                                              false; // Hide the gift card
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (_isLoading)
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: SpinKitCircle(
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 50,
                                  ),
                                ),
                              AnimatedOpacity(
                                opacity: _showGiftCard ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: _generatedMessage != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: GiftCardWidget(
                                          receiverName:
                                              _model.textController1!.text,
                                          senderName:
                                              _model.textController2!.text,
                                          message: _generatedMessage!,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).labelSmall.override(
                    fontFamily: 'Funnel Display',
                    useGoogleFonts: false,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: controller,
              autofocus: false,
              obscureText: false,
              maxLines: maxLines,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Funnel Display',
                    useGoogleFonts: false,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Funnel Display',
                      useGoogleFonts: false,
                      color: const Color(0x8B770404),
                      letterSpacing: 0.0,
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
