import '../../components/AdminComp/admin_order_card/admin_order_card_widget.dart';
import '../../components/AdminComp/admin_usr_rqst_card/admin_usr_rqst_card_widget.dart';
import '/custom/util.dart';
import 'admin_dashboard_widget.dart' show AdminDashboardWidget;
import 'package:flutter/material.dart';

class AdminDashboardModel extends FlutterFlowModel<AdminDashboardWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AdminUsrRqstCard component.
  late AdminUsrRqstCardModel adminUsrRqstCardModel1;
  // Model for AdminUsrRqstCard component.
  late AdminUsrRqstCardModel adminUsrRqstCardModel2;
  // Model for AdminUsrRqstCard component.
  late AdminUsrRqstCardModel adminUsrRqstCardModel3;
  // Model for AdminOrderCard component.
  late AdminOrderCardModel adminOrderCardModel;

  @override
  void initState(BuildContext context) {
    adminUsrRqstCardModel1 =
        createModel(context, () => AdminUsrRqstCardModel());
    adminUsrRqstCardModel2 =
        createModel(context, () => AdminUsrRqstCardModel());
    adminUsrRqstCardModel3 =
        createModel(context, () => AdminUsrRqstCardModel());
    adminOrderCardModel = createModel(context, () => AdminOrderCardModel());
  }

  @override
  void dispose() {
    adminUsrRqstCardModel1.dispose();
    adminUsrRqstCardModel2.dispose();
    adminUsrRqstCardModel3.dispose();
    adminOrderCardModel.dispose();
  }
}
