import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/pages/admin_dashboard/admin_dashboard_widget.dart';
import 'package:grad_roze/pages/admin_users_section/admin_users_section_widget.dart';
import '../order_section/admin_editing_widget.dart';
import '/custom/util.dart';

import 'navigation_menu_model.dart';
export 'navigation_menu_model.dart';

class NavigationMenuWidget extends StatefulWidget {
  const NavigationMenuWidget({super.key});

  @override
  State<NavigationMenuWidget> createState() => _NavigationMenuWidgetState();
}

class _NavigationMenuWidgetState extends State<NavigationMenuWidget> {
  late NavigationMenuModel _model;
  int _currentIndex = 0; // Keeps track of the current tab
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true; // Track loading state
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavigationMenuModel());

    // Simulate loading or perform your setup here
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Simulate an async operation like fetching data
      await Future.delayed(
          Duration(seconds: 1)); // Replace with your actual logic

      // Update the loading state
      setState(() {
        isLoading = false; // Loading is complete
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    // Return main layout once business name is fetched

    final List<Widget> pages = [
      const AdminDashboardWidget(),
      const AdminUsersSectionWidget(),
      const AdminEditingWidget(),
    ];

    return Scaffold(
      body: pages[_currentIndex], // Display the current page
      bottomNavigationBar: CircleNavBar(
        activeIndex: _currentIndex,
        height: 70, // Height of the navigation bar
        circleWidth: 60, // Size of the floating circle
        circleColor:
            FlutterFlowTheme.of(context).secondary, // Floating circle color

        activeIcons: const <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.supervisor_account_outlined, color: Colors.white),
          Icon(Icons.edit, color: Colors.white),
        ],
        inactiveIcons: <Widget>[
          Icon(Icons.home, color: FlutterFlowTheme.of(context).secondary),
          Icon(Icons.supervisor_account_outlined,
              color: FlutterFlowTheme.of(context).secondary),
          Icon(Icons.edit, color: FlutterFlowTheme.of(context).secondary),
        ],
        color: FlutterFlowTheme.of(context)
            .secondaryBackground, // Nav bar background color
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the active tab
          });
        },
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 5), // Removed the extra comma here
      ),
    );
  }
}
