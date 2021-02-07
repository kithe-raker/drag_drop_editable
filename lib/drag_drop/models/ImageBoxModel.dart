import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ImageBoxModel {
  String id;
  double fromTop, fromLeft, angle;
  Uint8List bytes;
  double width;
  double height;
  double ratio;
  ImageBoxModel(
      {@required this.id,
      @required this.fromLeft,
      @required this.fromTop,
      @required this.height,
      @required this.width,
      @required this.angle,
      @required this.bytes,
      @required this.ratio});

  factory ImageBoxModel.intit(String boxId, {@required Uint8List imageBytes}) {
    return ImageBoxModel(
        id: boxId,
        fromLeft: 32,
        fromTop: 64,
        height: 72,
        width: 120,
        angle: 0,
        bytes: imageBytes,
        ratio: 72 / 120);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageBoxModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
