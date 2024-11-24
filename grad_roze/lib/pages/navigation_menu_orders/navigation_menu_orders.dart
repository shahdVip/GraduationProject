import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/pages/admin_dashboard/admin_dashboard_widget.dart';
import 'package:grad_roze/pages/admin_users_section/admin_users_section_widget.dart';
import 'package:grad_roze/pages/order_section/order_section_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
import '/custom/util.dart';

import 'navigation_menu_orders_model.dart';
export 'navigation_menu_orders_model.dart';

class NavigationMenuOrdersWidget extends StatefulWidget {
  const NavigationMenuOrdersWidget({super.key});

  @override
  State<NavigationMenuOrdersWidget> createState() =>
      _NavigationMenuOrdersWidgetState();
}

class _NavigationMenuOrdersWidgetState
    extends State<NavigationMenuOrdersWidget> {
  late NavigationMenuOrdersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavigationMenuOrdersModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationOrdersController());
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

class NavigationOrdersController extends GetxController {
  final Rx<int> selectedIndex = 2.obs;

  final pages = [
    const AdminDashboardWidget(),
    const AdminUsersSectionWidget(),
    const OrderSectionWidget(),
  ];
}
