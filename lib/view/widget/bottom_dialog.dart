/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'package:flutter/material.dart';

/// Created On 2019/12/2
/// Description:
/// Dialog showing bottom
class BottomDialog extends StatefulWidget {
  // Name
  final String name;

  final List<Widget> widgets;

  final EdgeInsets margin;

  final Function onOutsideListener;

  BottomDialog(this.name, this.widgets, this.margin, this.onOutsideListener);

  @override
  _BottomDialogDialogState createState() =>
      _BottomDialogDialogState(name, widgets, onOutsideListener);
}

class _BottomDialogDialogState extends State<BottomDialog> {
  // Name
  final String name;

  final List<Widget> widgets;

  final Function onOutsideListener;

  _BottomDialogDialogState(this.name, this.widgets, this.onOutsideListener);

  @override
  Widget build(BuildContext context) {
    var opacity = Opacity(
      opacity: 0.3,
      child: ModalBarrier(dismissible: false, color: Colors.grey),
    );

    Widget card = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
    return Stack(
      children: <Widget>[
        opacity,
        GestureDetector(
          onTap: onOutsideListener ?? () => Navigator.of(context).pop(),
        ),
        Container(
          margin: widget.margin ??
              EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          alignment: Alignment.bottomCenter,
          child: card,
        ),
      ],
    );
  }
}
