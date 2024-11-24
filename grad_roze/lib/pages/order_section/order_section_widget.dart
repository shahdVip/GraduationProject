import '/components/order_list/order_list_widget.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'order_section_model.dart';
export 'order_section_model.dart';

class OrderSectionWidget extends StatefulWidget {
  const OrderSectionWidget({super.key});

  @override
  State<OrderSectionWidget> createState() => _OrderSectionWidgetState();
}

class _OrderSectionWidgetState extends State<OrderSectionWidget> {
  late OrderSectionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderSectionModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Text(
              'All Orders',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Funnel Display',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
            centerTitle: false,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 970,
                      ),
                      decoration: const BoxDecoration(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 0, 0),
                              child: Text(
                                'Below is a summary of orders.',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 8, 16, 8),
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController',
                                  const Duration(milliseconds: 2000),
                                  () => safeSetState(() {}),
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Search all orders...',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  suffixIcon: _model
                                          .textController!.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.textController?.clear();
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 22,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 16, 0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Text(
                                          'Order',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                useGoogleFonts: false,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1, 0),
                                      child: Text(
                                        'Price',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ]
                                      .addToStart(const SizedBox(width: 40))
                                      .addToEnd(const SizedBox(width: 40)),
                                ),
                              ),
                            ),
                            ListView(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                44,
                              ),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: wrapWithModel(
                                    model: _model.orderListModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: const OrderListWidget(),
                                  ),
                                ),
                              ].divide(const SizedBox(height: 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
