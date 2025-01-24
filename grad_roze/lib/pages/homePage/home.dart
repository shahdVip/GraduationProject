import 'package:flutter/material.dart';
import 'package:grad_roze/components/explore_widget/explore_widget.dart';
import 'package:grad_roze/components/bouqet_builder/bouqet_builder_widget.dart';
import 'package:grad_roze/custom/icon_button.dart';
import 'package:grad_roze/pages/chat_list/customer_chat_list.dart';
import 'package:grad_roze/pages/notifications/notifications_widget.dart';
import 'package:grad_roze/widgets/bouquetforeverymomentsection/bouquetforeverymomentsection_widget.dart';
import 'package:grad_roze/widgets/top_picks/top_picks_widget.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../widgets/CarouselSliderModel.dart';
export '../../widgets/CarouselSliderModel.dart';
export '../../widgets/MomentsModel.dart';

export '../../widgets/bouquetforeverymomentsection/bouquetforeverymomentsection_model.dart';
export '../../widgets/top_picks/top_picks_model.dart';
export '../../widgets/top_picks_component/top_picks_component_model.dart';

export '../../widgets/CustomizeSectionModel.dart';
export '../../widgets/CustomizeSectionWidget.dart';

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CarouselSliderWidget(),
            const SizedBox(height: 20),
            BouquetforeverymomentsectionWidget(username: username),
            const SizedBox(height: 20),
            TopPicksWidget(username: username),
            const SizedBox(height: 20),
            const BouqetBuilderWidget(),
            const SizedBox(height: 20),
            ExploreWidget(username: username),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/band.png', // Replace with your image path
        height: 40.0, // Adjust the height of the image
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          print('profile button');
          context.pushNamed('myprofileCustomer');
        },
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedUserCircle,
          color: Colors.black,
          size: 24.0,
        ),
        padding: const EdgeInsets.all(10), // Add padding to match the margin
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 24, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // or spaceAround

            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 24,
                icon: Icon(
                  HugeIcons.strokeRoundedNotification01,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsWidget(), // Replace with your page
                    ),
                  ); // context.pushNamed('cart'); // Navigate to the home page
                },
              ),
              //   SizedBox(width: 10),
              //   FlutterFlowIconButton(
              //     borderColor: Colors.transparent,
              //     borderRadius: 30,
              //     borderWidth: 1,
              //     buttonSize: 24,
              //     icon: Icon(
              //       HugeIcons.strokeRoundedChatting01,
              //       color: FlutterFlowTheme.of(context).primary,
              //       size: 24.0,
              //     ),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => CustomerChatListPage(
              //               userId: username), // Replace with your page
              //         ),
              //       ); // context.pushNamed('cart'); // Navigate to the home page
              //     },
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Type to find florist...';
  List<String> searchTerms = [
    'sewar',
    'shahd',
    'roa',
    'noor',
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Funnel Display',
          color: Color(0xFF040425), // Search bar text color
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255)), // Hint text color
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white, // Search bar background color
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(
            color: FlutterFlowTheme.of(context).primary), // Back button color
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Color(0xFF040425)),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back,
            color: Color(0xFF040425))); // Back icon
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
              title: Text(
            result,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 76, 91, 175), // Result text color
              fontWeight: FontWeight.bold,
            ),
          ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
              title: Text(
            result,
            style: const TextStyle(
              fontFamily: 'Funnel Display',
              fontSize: 14,
              color: Color(0xff770404), // Result text color
              fontWeight: FontWeight.w600,
            ),
          ));
        });
  }
}

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({super.key});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  late CarouselSliderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarouselSliderModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: CarouselSlider(
        items: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/slider/clothesAI.webp',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0x00F0F0F0),
                        FlutterFlowTheme.of(context).accent1,
                        FlutterFlowTheme.of(context).secondaryBackground
                      ],
                      stops: const [0, 0.5, 1],
                      begin: const AlignmentDirectional(0, -1),
                      end: const AlignmentDirectional(0, 1),
                    ),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Matching Bouquet',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                          Text(
                            'What are you wearing today?',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/slider/customize.webp',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0x00F0F0F0),
                        FlutterFlowTheme.of(context).accent1,
                        FlutterFlowTheme.of(context).secondaryBackground
                      ],
                      stops: const [0, 0.5, 1],
                      begin: const AlignmentDirectional(0, -1),
                      end: const AlignmentDirectional(0, 1),
                    ),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Customize Bouquet',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                          Text(
                            'Make your own bouquet',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/slider/moment.webp',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0x00F0F0F0),
                        FlutterFlowTheme.of(context).accent1,
                        FlutterFlowTheme.of(context).secondaryBackground
                      ],
                      stops: const [0, 0.5, 1],
                      begin: const AlignmentDirectional(0, -1),
                      end: const AlignmentDirectional(0, 1),
                    ),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Meaningful Bouquet',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                          Text(
                            'let your moment unforgetable',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        carouselController: _model.carouselController ??=
            CarouselSliderController(),
        options: CarouselOptions(
          initialPage: 1,
          viewportFraction: 0.7,
          disableCenter: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.25,
          enableInfiniteScroll: true,
          scrollDirection: Axis.horizontal,
          autoPlay: true, // Enable auto-play
          autoPlayInterval:
              const Duration(seconds: 3), // Interval between auto-play slides
          autoPlayAnimationDuration:
              const Duration(milliseconds: 800), // Animation duration
          autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
          onPageChanged: (index, _) => _model.carouselCurrentIndex = index,
        ),
      ),
    );
  }
}
