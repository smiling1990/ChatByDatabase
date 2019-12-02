/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */
import 'package:flutter/material.dart';

/// Created On 2019/12/2
/// Description:
/// Dialog
class CommonDialog extends StatefulWidget {
  // Name
  final String name;

  final List<Widget> widgets;

  final EdgeInsets margin;

  final Function onOutsideListener;

  CommonDialog(this.name, this.widgets, this.margin, this.onOutsideListener);

  @override
  _CommonDialogDialogState createState() =>
      _CommonDialogDialogState(name, widgets, onOutsideListener);
}

class _CommonDialogDialogState extends State<CommonDialog> {
  // Name
  final String name;

  final List<Widget> widgets;

  final Function onOutsideListener;

  _CommonDialogDialogState(this.name, this.widgets, this.onOutsideListener);

  @override
  Widget build(BuildContext context) {
    var opacity = Opacity(
      opacity: 0.3,
      child: ModalBarrier(dismissible: false, color: Colors.grey),
    );
    Widget card = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
          margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 30.0),
          alignment: Alignment.center,
          child: card,
        ),
      ],
    );
  }
}
