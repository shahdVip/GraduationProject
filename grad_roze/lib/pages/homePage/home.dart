import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grad_roze/components/explore_widget/explore_widget.dart';
import 'package:grad_roze/widgets/bouquetforeverymomentsection/bouquetforeverymomentsection_widget.dart';
import 'package:grad_roze/widgets/top_picks/top_picks_widget.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/CarouselSliderModel.dart';
export '../../widgets/CarouselSliderModel.dart';

export '../../widgets/MomentsModel.dart';

export '../../widgets/bouquetforeverymomentsection/bouquetforeverymomentsection_model.dart';
export '../../widgets/top_picks/top_picks_model.dart';
export '../../widgets/top_picks_component/top_picks_component_model.dart';

import '../../widgets/CustomizeSectionWidget.dart';
import '../../widgets/CustomizeSectionModel.dart';
export '../../widgets/CustomizeSectionModel.dart';
export '../../widgets/CustomizeSectionWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            CarouselSliderWidget(),
            SizedBox(height: 20),
            BouquetforeverymomentsectionWidget(),
            SizedBox(height: 20),
            TopPicksWidget(),
            SizedBox(height: 20),
            ExploreWidget(),
            SizedBox(height: 20),
            CustomizeSectionWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Roze',
        style: FlutterFlowTheme.of(context).titleLarge.override(
              fontFamily: 'Funnel Display',
              useGoogleFonts: false,
            ),
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F8), //COLOR OF THE BACKGROUND!
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/user.svg',
            height: 17,
            width: 17,
          ),
        ),
      ), //container
      actions: [
        SearchDelegate(context),
      ],
    );
  }

  GestureDetector SearchDelegate(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(
        context: context,
        delegate: CustomSearchDelegate(),
      ),
      child: Container(
        width: 37,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F8), //COLOR OF THE BACKGROUND!
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/search.svg',
          height: 17,
          width: 17,
        ),
      ),
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
              Duration(seconds: 3), // Interval between auto-play slides
          autoPlayAnimationDuration:
              Duration(milliseconds: 800), // Animation duration
          autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
          onPageChanged: (index, _) => _model.carouselCurrentIndex = index,
        ),
      ),
    );
  }
}
