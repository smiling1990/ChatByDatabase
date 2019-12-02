/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'package:flutter/material.dart';
import 'package:chatbydatabase/config/config.dart';

/// Created On 2019/12/2
/// Description: Bottom btn
///
class DialogBottomWidget extends StatelessWidget {
  /// Cancel and Apply
  final String leftBtn;
  final String rightBtn;
  final Function onCancel;
  final Function onApplyCallback;

  DialogBottomWidget({
    this.leftBtn,
    this.rightBtn,
    this.onCancel,
    this.onApplyCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: 56.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 30.0),
            child: Text(
              leftBtn,
              style: TextStyle(
                color: Config.primaryColor,
                fontWeight: FontWeight.normal,
                fontSize: Config.smallTextSize_2,
              ),
            ),
          ),
          onTap: onCancel ?? () => Navigator.of(context).pop(),
        ),
        RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            rightBtn,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: Config.commonTextSize,
            ),
          ),
          color: Config.primaryColor,
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          onPressed: onApplyCallback ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
