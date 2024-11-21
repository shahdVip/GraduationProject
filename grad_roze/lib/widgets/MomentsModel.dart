import 'package:grad_roze/widgets/moments_widget.dart';

import '/custom/util.dart';
import 'package:flutter/material.dart';

class MomentsModel extends FlutterFlowModel<MomentsWidget> {
  late final String imageUrl;
  late final String text;

  MomentsModel({required this.imageUrl, required this.text});

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  factory MomentsModel.fromJson(Map<String, dynamic> json) {
    return MomentsModel(
      imageUrl: json['imageUrl'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
