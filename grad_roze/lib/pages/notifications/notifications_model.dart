import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/components/notification_card/notification_card_widget.dart';
import 'notifications_widget.dart' show NotificationsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationsModel extends FlutterFlowModel<NotificationsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for notificationCard component.
  late NotificationCardModel notificationCardModel;

  @override
  void initState(BuildContext context) {
    notificationCardModel = createModel(context, () => NotificationCardModel());
  }

  @override
  void dispose() {
    notificationCardModel.dispose();
  }
}
