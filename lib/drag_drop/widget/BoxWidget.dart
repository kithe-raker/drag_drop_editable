import 'package:drag_drop_editable/drag_drop/widget/ManipulatingBall.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class BoxWidget extends StatefulWidget {
  ///give child widget to this box widget
  final Widget child;

  ///height of this box widget
  final double height;

  ///width of this box widget
  final double width;

  ///original ratio of box
  final double originRatio;

  ///angel of this box widget
  final double angle;

  ///[fromTop] is position form top of canvas
  final double fromTop;

  ///[fromLeft] is position form left of canvas
  final double fromLeft;

  ///whether box widget is editable
  ///
  ///default is [true]
  final bool editable;

  ///when box widget was tapped
  final Function onTap;

  ///when width was changed
  final Function(double width, double fromLeft) onWidthChange;

  ///when height was changed
  final Function(double height, double fromTop) onHeightChange;

  ///when box widget was draged
  final Function(double fromLeft, double fromTop) onDrag;

  ///when box widget was expaned
  final Function(double width, double height, double fromLeft, double fromTop)
      onExpand;
  BoxWidget(
      {@required this.height,
      @required this.width,
      @required this.child,
      @required this.fromLeft,
      @required this.fromTop,
      @required this.angle,
      this.onTap,
      this.onWidthChange,
      this.onHeightChange,
      this.onDrag,
      this.onExpand,
      this.editable = true,
      this.originRatio = 1.0});
  @override
  _BoxWidgetState createState() => _BoxWidgetState();
}

class _BoxWidgetState extends State<BoxWidget> {
  static const Color _blue = Color(0xff60A0FF);

  double _height, _width;
  double _fromTop = 0, _fromLeft = 0;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    _height = widget.height ?? 72;
    _width = widget.width ?? 120;
    _fromTop = widget.fromTop ?? 20;
    _fromLeft = widget.fromLeft ?? 20;
  }

  @override
  void didUpdateWidget(BoxWidget oldWidget) {
    _initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ratio =
        (_height / _width).isNaN ? widget.originRatio : _height / _width;
    return Positioned(
      width: widget.width + 2 * ballDiameter,
      height: widget.height + 2 * ballDiameter,
      top: _fromTop,
      left: _fromLeft,
      child: Transform.rotate(
        alignment: FractionalOffset.center,
        angle: widget.angle * (math.pi / 180),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Stack(children: <Widget>[
            Center(
                child: ManipulatingBall(
                    child: Container(
                        height: widget.height,
                        width: widget.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: widget.editable
                                    ? _blue
                                    : Colors.transparent,
                                width: 2.1)),
                        child: widget.child),
                    isDragWidget: true,
                    onDrag: widget.editable
                        ? (dx, dy, details) {
                            _fromLeft += dx;
                            _fromTop += dy;
                            widget.onDrag?.call(_fromLeft, _fromTop);
                          }
                        : null)),
            // top left
            Positioned(
                top: ballDiameter / 2,
                left: ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var mid = (dx + dy) / 2;
                        var newHeight = _height - 2 * mid;
                        var newWidth = newHeight / ratio;

                        _height = newHeight > 0 ? newHeight : 0;
                        _width = newWidth > 0 ? newWidth : 0;
                        if (_height > 0 && _width > 0) {
                          _fromTop = _fromTop + mid;
                          _fromLeft = _fromLeft + mid;
                        }
                        widget.onExpand
                            ?.call(_width, _height, _fromLeft, _fromTop);
                      })
                    : SizedBox()),
            // top middle
            Positioned(
                top: ballDiameter / 2,
                left: _width / 2 + ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(
                        onDrag: (dx, dy) {
                          var newHeight = _height - dy;
                          _height = newHeight > 0 ? newHeight : 0;
                          if (_height > 0) _fromTop += dy / 2;
                          widget.onHeightChange?.call(_height, _fromTop);
                        },
                      )
                    : SizedBox()),
            // top right
            Positioned(
                top: ballDiameter / 2,
                left: _width + ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var mid = (dx + (dy * -1)) / 2;
                        var newHeight = _height + 2 * mid;
                        var newWidth = newHeight / ratio;

                        _height = newHeight > 0 ? newHeight : 0;
                        _width = newWidth > 0 ? newWidth : 0;
                        if (_height > 0 && _width > 0) {
                          _fromTop = _fromTop - mid;
                          _fromLeft = _fromLeft - mid;
                        }
                        widget.onExpand
                            ?.call(_width, _height, _fromLeft, _fromTop);
                      })
                    : SizedBox()),
            // center right
            Positioned(
                top: _height / 2 + ballDiameter / 2,
                left: _width + ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var newWidth = _width + dx;
                        _width = newWidth > 0 ? newWidth : 0;
                        if (_width > 0) _fromLeft -= dx / 2;
                        widget.onWidthChange?.call(_width, _fromLeft);
                      })
                    : SizedBox()),
            // bottom right
            Positioned(
                top: _height + ballDiameter / 2,
                left: _width + ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var mid = (dx + dy) / 2;
                        var newHeight = _height + 2 * mid;
                        var newWidth = newHeight / ratio;

                        _height = newHeight > 0 ? newHeight : 0;
                        _width = newWidth > 0 ? newWidth : 0;
                        if (_height > 0 && _width > 0) {
                          _fromTop = _fromTop - mid;
                          _fromLeft = _fromLeft - mid;
                        }
                        widget.onExpand
                            ?.call(_width, _height, _fromLeft, _fromTop);
                      })
                    : SizedBox()),
            // bottom center
            Positioned(
                top: _height + ballDiameter / 2,
                left: _width / 2 + ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var newHeight = _height + dy;
                        _height = newHeight > 0 ? newHeight : 0;
                        if (_height > 0) _fromTop -= dy / 2;
                        widget.onHeightChange?.call(_height, _fromTop);
                      })
                    : SizedBox()),
            // bottom left
            Positioned(
                top: _height + ballDiameter / 2,
                left: ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var mid = ((dx * -1) + dy) / 2;
                        var newHeight = _height + 2 * mid;
                        var newWidth = newHeight / ratio;

                        _height = newHeight > 0 ? newHeight : 0;
                        _width = newWidth > 0 ? newWidth : 0;
                        if (_height > 0 && _width > 0) {
                          _fromTop = _fromTop - mid;
                          _fromLeft = _fromLeft - mid;
                        }
                        widget.onExpand
                            ?.call(_width, _height, _fromLeft, _fromTop);
                      })
                    : SizedBox()),
            //left center
            Positioned(
                top: _height / 2 + ballDiameter / 2,
                left: ballDiameter / 2,
                child: widget.editable
                    ? ManipulatingBall(onDrag: (dx, dy) {
                        var newWidth = _width - dx;
                        _width = newWidth > 0 ? newWidth : 0;
                        if (_width > 0) _fromLeft += dx / 2;
                        widget.onWidthChange?.call(_width, _fromLeft);
                      })
                    : SizedBox()),
          ]),
        ),
      ),
    );
  }
}
