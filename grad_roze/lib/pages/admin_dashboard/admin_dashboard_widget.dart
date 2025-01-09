import 'package:grad_roze/config.dart';
import 'package:grad_roze/pages/chat_list/customer_chat_list.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AdminComp/Insights/OrderSummaryWidget.dart';
import '../../components/AdminComp/Insights/TopBusinessesWidget.dart';
import 'package:grad_roze/components/AdminComp/Insights/UserSummaryWidget.dart';
import '../../components/AdminComp/admin_usr_rqst_card/admin_usr_rqst_card_widget.dart';
import '/custom/animations.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'admin_dashboard_model.dart';
export 'admin_dashboard_model.dart';

class AdminDashboardWidget extends StatefulWidget {
  const AdminDashboardWidget({super.key});

  @override
  State<AdminDashboardWidget> createState() => _AdminDashboardWidgetState();
}

class _AdminDashboardWidgetState extends State<AdminDashboardWidget>
    with TickerProviderStateMixin {
  late AdminDashboardModel _model;
  bool isLoading = true; // Track loading state
  String username = '';
  String userEmail = '';
  String userprofilePhotoUrl = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  List<dynamic> userRequests = []; // List to store user requests

  void _removeRequest(String username) {
    setState(() {
      userRequests.removeWhere((request) => request['username'] == username);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserRequests(); // Fetch the user requests when the widget is initialized
    _fetchUserProfile();
    _model = createModel(context, () => AdminDashboardModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.698, 0),
            end: const Offset(0, 0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.698, 0),
            end: const Offset(0, 0),
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

  // Fetch data from the backend API
  Future<void> fetchUserRequests() async {
    try {
      // Update the URL to point to your backend endpoint
      final response = await http.get(Uri.parse(fetchUserRequestUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body); // Decode the JSON data
        setState(() {
          userRequests = data; // Update the state with the fetched data
        });
      } else {
        // Handle error if request fails
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to load user requests'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // Retrieve the token
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(loggedInInfo),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            username = data['username']; // Set the fetched username
            userEmail = data['email'];
            userprofilePhotoUrl = data['profilePhoto'];
            isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading even if error occurs
          });
          print('Failed to load profile');
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading in case of error
        });
        print('Error: $e');
      }
    } else {
      setState(() {
        isLoading = false; // Stop loading when no token is found
      });
      print('No token found');
    }
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondary,
              automaticallyImplyLeading: false,
              title: Text(
                'Admin Dashboard',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Funnel Display',
                      useGoogleFonts: false,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              elevation: 4.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 10),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // or spaceAround

                    children: [
                      FlutterFlowIconButton(
                        buttonSize: 24,
                        icon: Icon(
                          HugeIcons.strokeRoundedUserCircle,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pushNamed('Adminprofile');
                        },
                      ),
                      SizedBox(width: 10),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        borderWidth: 1,
                        buttonSize: 24,
                        icon: Icon(
                          HugeIcons.strokeRoundedChatting01,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerChatListPage(
                                  userId: username), // Replace with your page
                            ),
                          ); // context.pushNamed('cart'); // Navigate to the home page
                        },
                      ),
                    ],
                  ),
                ),
              ],
              centerTitle: false,
            ),
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent insights',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Funnel Display',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    UserSummaryWidget(),
                    const SizedBox(height: 16.0),
                    TopBusinessesWidget(),
                    const SizedBox(height: 16.0),
                    OrderSummaryWidget(),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      height: 315,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x33000000),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Requests',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Funnel Display',
                                    useGoogleFonts: false,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            Expanded(
                              child: userRequests.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No new requests',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    )
                                  : Row(
                                      children: userRequests
                                          .take(5)
                                          .map((userRequest) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: AdminUsrRqstCardWidget(
                                                  username:
                                                      userRequest['username'],
                                                  role: userRequest['role'],
                                                  profilePhoto: userRequest[
                                                      'profilePhoto'],
                                                  timestamp:
                                                      userRequest['createdAt'],
                                                  onRequestProcessed:
                                                      _removeRequest,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: AlignmentDirectional.center,
                              child: FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed('AdminUsersSectionWithNav');
                                },
                                text: 'Show more',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  color: const Color(0x00F83B46),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
