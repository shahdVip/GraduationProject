import 'package:grad_roze/config.dart';

import '/custom/swipeable_stack.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/custom/animations.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences

import 'package:flutter_animate/flutter_animate.dart';

import 'mood_quiz_model.dart';
export 'mood_quiz_model.dart';

class MoodQuizWidget extends StatefulWidget {
  const MoodQuizWidget({
    super.key,
  });

  @override
  State<MoodQuizWidget> createState() => _MoodQuizWidgetState();
}

class _MoodQuizWidgetState extends State<MoodQuizWidget>
    with TickerProviderStateMixin {
  int cardIndex = 0;
  //String itemId = 'a';
  late MoodQuizModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  Future<void> initializeUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username =
        prefs.getString('username'); // Get username from shared preferences
    print(username);

    if (username == null) {
      print("Username not found, user needs to sign in");
      return;
    }

    // Prepare the URL for the endpoint
    final url = Uri.parse(initilizePreferenceUrl);

    // Create the body to send in the POST request
    final body = json.encode({'username': username});

    try {
      // Make the HTTP request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Handle the success response
        print('User preferences initialized successfully: ${response.body}');
      } else {
        // Handle the error response
        print('Failed to initialize user preferences: ${response.body}');
      }
    } catch (error) {
      print('Error occurred while calling the endpoint: $error');
    }
  }

  Future<void> updateUserPreferences(int cardIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final String? username =
        prefs.getString('username'); // Get username from shared preferences

    if (username == null) {
      print("Username not found, user needs to sign in");
      return;
    }

    // Prepare the URL for the endpoint
    final url = Uri.parse(updatePreferenceUrl);
    String body = '';
    switch (cardIndex) {
      case 0:
        body = json.encode({
          'username': username,
          'color': ['white'], // Customize based on cardIndex
          'flowerType': ['rose'], // Customize based on cardIndex
          'tag': [
            'Engagement',
            'Congratulations'
          ], // Customize based on cardIndex
        });
        break;
      case 1:
        body = json.encode({
          'username': username,
          'color': ['yellow'], // Customize based on cardIndex
          'flowerType': ['sunflower'], // Customize based on cardIndex
          'tag': [
            'Thank You',
            'Get Well Soon '
          ], // Customize based on cardIndex
        });
        break;
      case 2:
        body = json.encode({
          'username': username,
          'color': ['white'], // Customize based on cardIndex
          'flowerType': ['lily'], // Customize based on cardIndex
          'tag': [
            'Engagement',
            'Get Well Soon'
          ], // Customize based on cardIndex
        });
        break;
      case 3:
        body = json.encode({
          'username': username,
          'color': ['red'], // Customize based on cardIndex
          'flowerType': ['rose'], // Customize based on cardIndex
          'tag': ['Engagement'], // Customize based on cardIndex
        });
        break;
      case 4:
        body = json.encode({
          'username': username,
          'color': ['pink', 'orange'], // Customize based on cardIndex
          'flowerType': ['tulip'], // Customize based on cardIndex
          'tag': [
            'Thank You',
          ], // Customize based on cardIndex
        });
        break;
      case 5:
        body = json.encode({
          'username': username,
          'color': ['pink', 'orange', 'white'], // Customize based on cardIndex
          'flowerType': ['peony'], // Customize based on cardIndex
          'tag': ['Get Well Soon', 'Thank You'], // Customize based on cardIndex
        });
        break;
      case 6:
        body = json.encode({
          'username': username,
          'color': ['yellow'], // Customize based on cardIndex
          'flowerType': ['calla'], // Customize based on cardIndex
          'tag': [
            'Engagement',
          ], // Customize based on cardIndex
        });
        break;
      case 7:
        body = json.encode({
          'username': username,
          'color': ['pink'], // Customize based on cardIndex
          'flowerType': ['orchid'], // Customize based on cardIndex
          'tag': [
            'Thank You',
            'Congratulations'
          ], // Customize based on cardIndex
        });
        break;
      case 8:
        body = json.encode({
          'username': username,
          'color': ['white', 'pink'], // Customize based on cardIndex
          'flowerType': [
            'gerbera',
            'chrysanthemum',
            'rose'
          ], // Customize based on cardIndex
          'tag': ['Thank You', 'Get Well Soon'], // Customize based on cardIndex
        });
        break;
      case 9:
        body = json.encode({
          'username': username,
          'color': ['pink', 'purple', 'blue'], // Customize based on cardIndex
          'flowerType': [
            'chrysanthemums',
            'Hydrangea',
          ], // Customize based on cardIndex
          'tag': [
            'Get Well Soon',
          ], // Customize based on cardIndex
        });
        break;
      case 10:
        body = json.encode({
          'username': username,
          'color': ['blue'], // Customize based on cardIndex
          'flowerType': [
            'crocus',
          ], // Customize based on cardIndex
          'tag': [
            'Get Well Soon',
          ], // Customize based on cardIndex
        });
        break;
      default:
        break;
    }

    // Prepare the body to send in the PUT request based on cardIndex
    // final body = json.encode({
    //   'username': username,
    //   'color': 'someColorBasedOnCardIndex', // Customize based on cardIndex
    //   'flowerType': 'someFlowerTypeBasedOnCardIndex', // Customize based on cardIndex
    //   'tag': 'someTagBasedOnCardIndex', // Customize based on cardIndex
    // });

    try {
      // Make the HTTP request
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Handle the success response
        print('User preferences updated successfully: ${response.body}');
      } else {
        // Handle the error response
        print('Failed to update user preferences: ${response.body}');
      }
    } catch (error) {
      print('Error occurred while calling the endpoint: $error');
    }
  }

  // Future<String> fetchItemData(String itemId) async {
  //   final response =
  //       await http.get(Uri.parse('http://192.168.1.8:3000/item/items/$itemId'));

  //   if (response.statusCode == 200) {
  //     final itemData = json.decode(response.body);
  //     String imageUrl = itemData[
  //         'imageURL']; // Assuming this returns just the relative path, e.g., '/uploads/1731989332624.jpeg'

  //     // Concatenate the base URL with the relative image path
  //     String fullImageUrl =
  //         '$baseUrl$imageUrl'; // Full URL: http://your-backend-server.com/uploads/1731989332624.jpeg
  //     return fullImageUrl;
  //   } else {
  //     throw Exception('Failed to load item data');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initializeUserPreferences();

    _model = createModel(context, () => MoodQuizModel());

    animationsMap.addAll({
      'iconOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 700.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(3.0, 3.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 700.0.ms,
            begin: const Offset(0.0, 15.0),
            end: const Offset(35.0, 0.0),
          ),
        ],
      ),
      'iconOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 700.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(3.0, 3.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 700.0.ms,
            begin: const Offset(0.0, 15),
            end: const Offset(-35.0, 0.0),
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
            title: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/favicon.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (cardIndex < 10)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Text(
                        'Discover Your Favorites',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Funnel Display',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  if (cardIndex < 10)
                    Text(
                      'Swipe right if you like the product and left if you don’t to receive personalized recommendations!',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Funnel Display',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            useGoogleFonts: false,
                          ),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        FlutterFlowSwipeableStack(
                          onSwipeFn: (index) {},
                          onLeftSwipe: (index) async {
                            setState(() {
                              cardIndex++;
                            });

                            if (animationsMap[
                                    'iconOnActionTriggerAnimation2'] !=
                                null) {
                              await animationsMap[
                                      'iconOnActionTriggerAnimation2']!
                                  .controller
                                  .forward(from: 0.0)
                                  .whenComplete(() => animationsMap[
                                          'iconOnActionTriggerAnimation2']!
                                      .controller
                                      .reverse());
                            }
                          },
                          onRightSwipe: (index) async {
                            //update the user preference
                            await updateUserPreferences(cardIndex);

                            setState(() {
                              cardIndex++;
                            });

                            if (animationsMap[
                                    'iconOnActionTriggerAnimation1'] !=
                                null) {
                              await animationsMap[
                                      'iconOnActionTriggerAnimation1']!
                                  .controller
                                  .forward(from: 0.0)
                                  .whenComplete(() => animationsMap[
                                          'iconOnActionTriggerAnimation1']!
                                      .controller
                                      .reverse());
                            }
                          },
                          onUpSwipe: (index) {},
                          onDownSwipe: (index) {},
                          itemBuilder: (context, index) {
                            return [
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/1.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/2.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/3.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/4.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/5.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/6.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/7.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/8.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/9.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/10.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              () => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/moodQuiz/11.jpg',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ][index]();
                          },
                          itemCount: 10,
                          controller: _model.swipeableStackController,
                          loop: false,
                          cardDisplayCount: 3,
                          scale: 0.9,
                        ),
                        Align(
                          alignment: const AlignmentDirectional(1, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 25, 0),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xD5770404),
                              size: 70,
                            ).animateOnActionTrigger(
                              animationsMap['iconOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 0, 0),
                            child: const Icon(
                              Icons.heart_broken_rounded,
                              color: Color(0xE37C8890),
                              size: 70,
                            ).animateOnActionTrigger(
                              animationsMap['iconOnActionTriggerAnimation2']!,
                            ),
                          ),
                        ),
                        if (cardIndex >= 10)
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Your wish, our command. \nHappy browsing!',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      context.pushNamed('HomePage');
                                    },
                                    text: 'Home',
                                    options: FFButtonOptions(
                                      width: 130,
                                      height: 40,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      color: const Color(0x00FFFFFF),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
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
