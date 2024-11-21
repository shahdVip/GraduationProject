import 'package:flutter/material.dart';
import 'package:grad_roze/custom/model.dart';
import '../../services/moment_service.dart';
import '/widgets/MomentsModel.dart';
import 'package:grad_roze/widgets/bouquetforeverymomentsection/bouquetforeverymomentsection_widget.dart';

class BouquetforeverymomentsectionModel
    extends FlutterFlowModel<BouquetforeverymomentsectionWidget> {
  /// State fields for stateful widgets in this component.

  // List of moments fetched dynamically
  late Future<List<MomentsModel>> momentsFuture;

  @override
  void initState(BuildContext context) {
    // Fetch moments from the backend
    momentsFuture = MomentService.fetchMoments();
  }

  @override
  void dispose() {
    // No special cleanup needed for dynamic fetching
  }
}
