import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/pages/admin_dashboard/admin_dashboard_widget.dart';
import 'package:grad_roze/pages/admin_users_section/admin_users_section_widget.dart';
import 'package:grad_roze/pages/order_section/order_section_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavigationMenuModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(() => controller.pages[controller.selectedIndex.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.selectedIndex.value = index,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            selectedItemColor: FlutterFlowTheme.of(context).secondary,
            unselectedItemColor: FlutterFlowTheme.of(context).primary,
            selectedLabelStyle:
                FlutterFlowTheme.of(context).labelLarge.override(
                      fontFamily: 'Funnel Display',
                      useGoogleFonts: false,
                      letterSpacing: 0.0,
                      color: FlutterFlowTheme.of(context).secondary,
                      fontWeight: FontWeight.w600,
                    ),
            unselectedLabelStyle:
                FlutterFlowTheme.of(context).labelLarge.override(
                      fontFamily: 'Funnel Display',
                      useGoogleFonts: false,
                      letterSpacing: 0.0,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
            items: [
              BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome02,
                  color: controller.selectedIndex.value == 0
                      ? FlutterFlowTheme.of(context).secondary
                      : FlutterFlowTheme.of(context).primary,
                  size: 30.0,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserGroup,
                  color: controller.selectedIndex.value == 1
                      ? FlutterFlowTheme.of(context).secondary
                      : FlutterFlowTheme.of(context).primary,
                  size: 30.0,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPackageMoving,
                  color: controller.selectedIndex.value == 2
                      ? FlutterFlowTheme.of(context).secondary
                      : FlutterFlowTheme.of(context).primary,
                  size: 30.0,
                ),
                label: 'Orders',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final pages = [
    const AdminDashboardWidget(),
    const AdminUsersSectionWidget(),
    const OrderSectionWidget(),
  ];
}
