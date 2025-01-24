import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'dialog_model.dart';
export 'dialog_model.dart';

// class DialogWidget extends StatefulWidget {
//   const DialogWidget({super.key});

//   @override
//   State<DialogWidget> createState() => _DialogWidgetState();
// }

// class _DialogWidgetState extends State<DialogWidget> {
//   late DialogModel _model;

//   @override
//   void setState(VoidCallback callback) {
//     super.setState(callback);
//     _model.onUpdate();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => DialogModel());

//     _model.textController ??= TextEditingController();
//     _model.textFieldFocusNode ??= FocusNode();

//     WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
//   }

//   @override
//   void dispose() {
//     _model.maybeDispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Align(
//         alignment: AlignmentDirectional(0, 0),
//         child: Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
//           child: Container(
//             width: double.infinity,
//             height: 200,
//             constraints: BoxConstraints(
//               maxWidth: 530,
//             ),
//             decoration: BoxDecoration(
//               color: FlutterFlowTheme.of(context).secondaryBackground,
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 3,
//                   color: Color(0x33000000),
//                   offset: Offset(
//                     0,
//                     1,
//                   ),
//                 )
//               ],
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(
//                 color: FlutterFlowTheme.of(context).primaryBackground,
//                 width: 1,
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'New Chat',
//                           textAlign: TextAlign.start,
//                           style: FlutterFlowTheme.of(context)
//                               .headlineMedium
//                               .override(
//                                 fontFamily: 'Funnel Display',
//                                 color: FlutterFlowTheme.of(context).primary,
//                                 letterSpacing: 0.0,
//                                 useGoogleFonts: false,
//                               ),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
//                           child: Container(
//                             width: double.infinity,
//                             child: TextFormField(
//                               controller: _model.textController,
//                               focusNode: _model.textFieldFocusNode,
//                               onChanged: (_) => EasyDebounce.debounce(
//                                 '_model.textController',
//                                 Duration(milliseconds: 2000),
//                                 () => safeSetState(() {}),
//                               ),
//                               autofocus: false,
//                               obscureText: false,
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 hintText: 'Username',
//                                 hintStyle: FlutterFlowTheme.of(context)
//                                     .labelMedium
//                                     .override(
//                                       fontFamily: 'Funnel Display',
//                                       letterSpacing: 0.0,
//                                       useGoogleFonts: false,
//                                     ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: FlutterFlowTheme.of(context)
//                                         .secondaryText,
//                                     width: 1,
//                                   ),
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4.0),
//                                     topRight: Radius.circular(4.0),
//                                   ),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Color(0x00000000),
//                                     width: 1,
//                                   ),
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4.0),
//                                     topRight: Radius.circular(4.0),
//                                   ),
//                                 ),
//                                 errorBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: FlutterFlowTheme.of(context).error,
//                                     width: 1,
//                                   ),
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4.0),
//                                     topRight: Radius.circular(4.0),
//                                   ),
//                                 ),
//                                 focusedErrorBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: FlutterFlowTheme.of(context).error,
//                                     width: 1,
//                                   ),
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4.0),
//                                     topRight: Radius.circular(4.0),
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: FlutterFlowTheme.of(context)
//                                     .secondaryBackground,
//                                 contentPadding: EdgeInsetsDirectional.fromSTEB(
//                                     10, 10, 10, 10),
//                                 suffixIcon:
//                                     _model.textController!.text.isNotEmpty
//                                         ? InkWell(
//                                             onTap: () async {
//                                               _model.textController?.clear();
//                                               safeSetState(() {});
//                                             },
//                                             child: Icon(
//                                               Icons.clear,
//                                               size: 22,
//                                             ),
//                                           )
//                                         : null,
//                               ),
//                               style: FlutterFlowTheme.of(context)
//                                   .bodyMedium
//                                   .override(
//                                     fontFamily: 'Funnel Display',
//                                     color: FlutterFlowTheme.of(context).primary,
//                                     letterSpacing: 0.0,
//                                     useGoogleFonts: false,
//                                   ),
//                               validator: _model.textControllerValidator
//                                   .asValidator(context),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 12),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
//                           child: FFButtonWidget(
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .pop(); // Close dialog without value
//                             },
//                             text: 'Cancel',
//                             options: FFButtonOptions(
//                               height: 40,
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
//                               iconPadding:
//                                   EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                               color: FlutterFlowTheme.of(context)
//                                   .secondaryBackground,
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .labelMedium
//                                   .override(
//                                     fontFamily: 'Funnel Display',
//                                     letterSpacing: 0.0,
//                                     useGoogleFonts: false,
//                                   ),
//                               elevation: 0,
//                               borderRadius: BorderRadius.circular(40),
//                             ),
//                           ),
//                         ),
//                         FFButtonWidget(
//                           onPressed: () {
//                             Navigator.of(context).pop(
//                                 _model.textController?.text); // Return value
//                           },
//                           text: 'Submit',
//                           options: FFButtonOptions(
//                             height: 40,
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
//                             iconPadding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                             color: FlutterFlowTheme.of(context).secondary,
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleSmall
//                                 .override(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                   fontFamily: 'Funnel Display',
//                                   letterSpacing: 0.0,
//                                   useGoogleFonts: false,
//                                 ),
//                             elevation: 0,
//                             borderSide: BorderSide(
//                               color: Colors.transparent,
//                             ),
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final List<String> users; // Pass the list of users to search from
  final Function(String) onUserSelected; // Callback to handle selected user

  const DialogWidget({
    Key? key,
    required this.users,
    required this.onUserSelected,
  }) : super(key: key);

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  late List<String> filteredUsers; // List to store filtered users
  String searchQuery = ""; // Search query

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users; // Initially show all users
  }

  // Filter users based on the search query
  void _filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = widget.users
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search bar
            TextField(
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: 'Search Businesses',
                labelStyle: TextStyle(
                  color: FlutterFlowTheme.of(context)
                      .secondaryText, // Set the hint color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context)
                        .primary, // Set the border color when focused
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: FlutterFlowTheme.of(context)
                      .secondaryText, // Set the leading icon color
                ),
              ),
            ),

            const SizedBox(height: 16),
            // List of filtered users
            Expanded(
              child: filteredUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                          title: Text(user),
                          onTap: () {
                            widget.onUserSelected(user); // Return selected user

                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text('No users found'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
