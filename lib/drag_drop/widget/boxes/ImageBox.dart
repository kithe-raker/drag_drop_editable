import 'package:drag_drop_editable/drag_drop/models/ImageBoxModel.dart';
import 'package:drag_drop_editable/drag_drop/widget/BoxWidget.dart';
import 'package:flutter/material.dart';

class ImageBox extends StatefulWidget {
  ///referece to which image box
  final String id;

  ///[stream] of current image box data
  final Stream<ImageBoxModel> stream;

  ///handle when image was tapped
  final Function onTap;

  ///when box's width was changed
  final Function(double width, double fromLeft) onWidthChange;

  ///when box's height was changed
  final Function(double height, double fromTop) onHeightChange;

  ///when box was draged
  final Function(double fromLeft, double fromTop) onDrag;

  ///when box was expaned
  final Function(double width, double height, double fromLeft, double fromTop)
      onExpand;
  ImageBox(
      {@required this.stream,
      @required this.onWidthChange,
      @required this.onHeightChange,
      @required this.onDrag,
      @required this.onExpand,
      @required this.id,
      this.onTap});
  @override
  _ImageBoxState createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, AsyncSnapshot<ImageBoxModel> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return BoxWidget(
                originRatio: data.ratio,
                fromLeft: data.fromLeft,
                fromTop: data.fromTop,
                height: data.height,
                width: data.width,
                angle: data.angle,
                onDrag: widget.onDrag,
                onExpand: widget.onExpand,
                onHeightChange: widget.onHeightChange,
                onWidthChange: widget.onWidthChange,
                onTap: widget.onTap,
                child: SizedBox(
                  child: Image.memory(data.bytes, fit: BoxFit.cover),
                ));
          } else {
            return SizedBox();
          }
        });
  }
}
