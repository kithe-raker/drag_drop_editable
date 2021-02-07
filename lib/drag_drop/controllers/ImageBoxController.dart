import 'dart:typed_data';

import 'package:drag_drop_editable/drag_drop/models/ImageBoxModel.dart';
import 'package:drag_drop_editable/drag_drop/widget/boxes/ImageBox.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class ImageBoxController {
  ///[id] refer to this controller
  final String id;
  ImageBoxController(this.id);

  final _subject = BehaviorSubject<ImageBoxModel>();
  
  ///[_subject] is the controller's stream
  Stream<ImageBoxModel> get stream => _subject.stream;

  ///current value in [_subject]
  ImageBoxModel get value => _subject.value;

  ///initial [ImageBoxController]
  factory ImageBoxController.init(Uint8List imageBytes) {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final controller = ImageBoxController(id);
    final box = ImageBoxModel.intit(id, imageBytes: imageBytes);
    controller._subject.add(box);
    return controller;
  }

  ///update [ImageBoxModel] in this controller
  void update(
      {double fromTop,
      double fromLeft,
      double angle,
      Uint8List bytes,
      double width,
      double height}) {
    var newTextData = ImageBoxModel(
        id: id,
        ratio: value.ratio,
        fromLeft: fromLeft ?? value.fromLeft,
        fromTop: fromTop ?? value.fromTop,
        height: height ?? value.height,
        width: width ?? value.width,
        angle: angle ?? value.angle,
        bytes: bytes ?? value.bytes);

    _subject.add(newTextData);
  }

  ///Image box widget
  Widget get widget => ImageBox(
      stream: stream,
      id: this.id,
      onWidthChange: (double width, double fromLeft) {
        update(width: width, fromLeft: fromLeft);
      },
      onHeightChange: (double height, double fromTop) {
        update(height: height, fromTop: fromTop);
      },
      onDrag: (double fromLeft, double fromTop) {
        update(fromLeft: fromLeft, fromTop: fromTop);
      },
      onExpand: (double width, double height, double fromLeft, double fromTop) {
        update(
            width: width, height: height, fromLeft: fromLeft, fromTop: fromTop);
      });
}
