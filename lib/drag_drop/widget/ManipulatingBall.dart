import 'package:flutter/material.dart';

const double ballDiameter = 27.0;

class ManipulatingBall extends StatefulWidget {
  final Function onDrag;
  final Widget child;
  final bool isDragWidget;
  ManipulatingBall(
      {@required this.onDrag, this.isDragWidget = false, this.child});
  @override
  _ManipulatingWidgetState createState() => _ManipulatingWidgetState();
}

class _ManipulatingWidgetState extends State<ManipulatingBall> {
  double _initX;
  double _initY;

  void _handleDrag(details) {
    if (widget.isDragWidget) {
      _initX = details.globalPosition.dx;
      _initY = details.globalPosition.dy;
    } else {
      _initX = details.localPosition.dx;
      _initY = details.localPosition.dy;
    }
  }

  void _handleUpdate(DragUpdateDetails details) {
    if (widget.isDragWidget) {
      var dx = details.globalPosition.dx - _initX;
      var dy = details.globalPosition.dy - _initY;
      _initX = details.globalPosition.dx;
      _initY = details.globalPosition.dy;
      widget.onDrag(dx, dy, details);
    } else {
      var dx = details.localPosition.dx - _initX;
      var dy = details.localPosition.dy - _initY;
      _initX = details.localPosition.dx;
      _initY = details.localPosition.dy;
      widget.onDrag(dx, dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: _handleDrag,
        onPanUpdate: widget.onDrag != null ? _handleUpdate : null,
        child: widget.child ?? _ballWidget());
  }

  Widget _ballWidget() => Container(
      width: ballDiameter,
      height: ballDiameter,
      decoration:
          BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: Center(
          child: Container(
        width: 15,
        height: 15,
        decoration:
            BoxDecoration(color: Color(0xff60A0FF), shape: BoxShape.circle),
      )));
}
